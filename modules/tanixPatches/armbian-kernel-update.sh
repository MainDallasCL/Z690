#!/usr/bin/env bash
# armbian-kernel-update.sh
#
# Checks Armbian's repo for a newer linux-image-current-sunxi64 build than
# the currently RUNNING kernel (uname -r). If newer, downloads, extracts to
# /boot, and rewrites armbian-kernel.nix's version/modDirVersion in place.
#
# Designed to run as a pre-step inside a wrapped `nixos-rebuild` — see
# nixos-rebuild-wrapper.nix. Never touches the running system beyond staging
# files; the actual switch/reboot is still up to nixos-rebuild + the user.
#
# Safe to run repeatedly: if the remote version matches `uname -r`, it's a
# no-op (fast path, one network request). If it doesn't match but you've
# already staged this exact update on a previous run without rebooting yet,
# it'll re-stage the same version again — harmless, just a redundant download.

set -euo pipefail

## Stable Repo
# REPO_BASE="https://apt.armbian.com"
# PACKAGES_PATH="/dists/trixie/main/binary-arm64/Packages"

## Beta Repo (tracks newer/trunk builds under a "sid"-style suite name,
## separate from the stable repo's Debian-release-named suites)
REPO_BASE="https://beta.armbian.com"
PACKAGES_PATH="/dists/sid/main/binary-arm64/Packages"

# "current" or "edge" — change this one value to switch branches.
BRANCH="edge"

IMAGE_PKG="linux-image-${BRANCH}-sunxi64"
DTB_PKG="linux-dtb-${BRANCH}-sunxi64"
HEADERS_PKG="linux-headers-${BRANCH}-sunxi64"
LIBC_DEV_PKG="linux-libc-dev-${BRANCH}-sunxi64"

KERNEL_NIX="${KERNEL_NIX:-/etc/nixos/armbian-kernel.nix}"
BOOT_STAGE_DIR="${BOOT_STAGE_DIR:-/boot/armbian-kernel-src}"

log() { echo "[armbian-kernel-update] $*" >&2; }

if [[ ! -f "$KERNEL_NIX" ]]; then
  log "warning: $KERNEL_NIX not found, skipping update check"
  exit 0
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

log "checking for newer Armbian kernel..."

if ! curl -fsSL --max-time 15 "${REPO_BASE}/${PACKAGES_PATH}.gz" -o "${WORKDIR}/Packages.gz" 2>/dev/null; then
  if ! curl -fsSL --max-time 15 "${REPO_BASE}/${PACKAGES_PATH}" -o "${WORKDIR}/Packages" 2>/dev/null; then
    log "warning: could not reach ${REPO_BASE}, skipping update check"
    exit 0
  fi
else
  gunzip "${WORKDIR}/Packages.gz"
fi

extract_stanza() {
  local pkg="$1"
  awk -v pkg="Package: $pkg" '
    BEGIN { RS=""; FS="\n"; ORS="\0" }
    $1 == pkg { print }
  ' "${WORKDIR}/Packages"
}

# The index can list several builds of the same package simultaneously —
# pick the highest Version, not just the first stanza we happen to see.
pick_highest_version_stanza() {
  local pkg="$1"
  local best_version="" best_stanza=""
  local stanza v
  while IFS= read -r -d $'\0' stanza; do
    v="$(echo "$stanza" | grep '^Version:' | cut -d' ' -f2)"
    if [[ -z "$best_version" ]] || dpkg --compare-versions "$v" gt "$best_version"; then
      best_version="$v"
      best_stanza="$stanza"
    fi
  done < <(extract_stanza "$pkg")
  printf '%s' "$best_stanza"
}

IMAGE_STANZA="$(pick_highest_version_stanza "$IMAGE_PKG")"
if [[ -z "$IMAGE_STANZA" ]]; then
  log "warning: package '$IMAGE_PKG' not found in repo index, skipping"
  exit 0
fi

REMOTE_FAMILY="$(echo "$IMAGE_STANZA" | grep '^Armbian-Kernel-Version-Family:' | cut -d' ' -f2)"
IMAGE_FILENAME="$(echo "$IMAGE_STANZA" | grep '^Filename:' | cut -d' ' -f2)"
PKG_VERSION="$(echo "$IMAGE_STANZA" | grep '^Version:' | cut -d' ' -f2)"

# Find the stanza for a companion package (dtb/headers/libc-dev) matching the
# SAME package version as the chosen image — they must be from the same build.
find_matching_stanza() {
  local pkg="$1" want_version="$2"
  local stanza v
  while IFS= read -r -d $'\0' stanza; do
    v="$(echo "$stanza" | grep '^Version:' | cut -d' ' -f2)"
    if [[ "$v" == "$want_version" ]]; then
      printf '%s' "$stanza"
      return 0
    fi
  done < <(extract_stanza "$pkg")
  return 1
}

DTB_STANZA="$(find_matching_stanza "$DTB_PKG" "$PKG_VERSION")" || {
  log "warning: no matching $DTB_PKG for version $PKG_VERSION, skipping"
  exit 0
}
DTB_FILENAME="$(echo "$DTB_STANZA" | grep '^Filename:' | cut -d' ' -f2)"

HEADERS_STANZA="$(find_matching_stanza "$HEADERS_PKG" "$PKG_VERSION")" || {
  log "warning: no matching $HEADERS_PKG for version $PKG_VERSION, skipping"
  exit 0
}
HEADERS_FILENAME="$(echo "$HEADERS_STANZA" | grep '^Filename:' | cut -d' ' -f2)"

LIBC_DEV_STANZA="$(find_matching_stanza "$LIBC_DEV_PKG" "$PKG_VERSION")" || {
  log "warning: no matching $LIBC_DEV_PKG for version $PKG_VERSION, skipping"
  exit 0
}
LIBC_DEV_FILENAME="$(echo "$LIBC_DEV_STANZA" | grep '^Filename:' | cut -d' ' -f2)"

RUNNING_KERNEL="$(uname -r)"

log "running kernel:  $RUNNING_KERNEL"
log "available:       $REMOTE_FAMILY (package $PKG_VERSION)"

if [[ "$RUNNING_KERNEL" == "$REMOTE_FAMILY" ]]; then
  log "up to date, nothing to do"
  exit 0
fi

log "fetching ${IMAGE_FILENAME}..."
curl -fsSL --max-time 300 "${REPO_BASE}/${IMAGE_FILENAME}" -o "${WORKDIR}/image.deb"
log "fetching ${DTB_FILENAME}..."
curl -fsSL --max-time 60 "${REPO_BASE}/${DTB_FILENAME}" -o "${WORKDIR}/dtb.deb"
log "fetching ${HEADERS_FILENAME}..."
curl -fsSL --max-time 300 "${REPO_BASE}/${HEADERS_FILENAME}" -o "${WORKDIR}/headers.deb"
log "fetching ${LIBC_DEV_FILENAME}..."
curl -fsSL --max-time 60 "${REPO_BASE}/${LIBC_DEV_FILENAME}" -o "${WORKDIR}/libc-dev.deb"

log "extracting..."
mkdir -p "${WORKDIR}/extracted"
dpkg-deb -x "${WORKDIR}/image.deb" "${WORKDIR}/extracted"
dpkg-deb -x "${WORKDIR}/dtb.deb" "${WORKDIR}/extracted"
dpkg-deb -x "${WORKDIR}/headers.deb" "${WORKDIR}/extracted"
dpkg-deb -x "${WORKDIR}/libc-dev.deb" "${WORKDIR}/extracted"

# Sanity check: the extracted modules dir should match what the repo told us
EXTRACTED_MODDIR="$(basename "$(find "${WORKDIR}/extracted/lib/modules" -mindepth 1 -maxdepth 1 -type d)")"
if [[ "$EXTRACTED_MODDIR" != "$REMOTE_FAMILY" ]]; then
  log "warning: extracted version ($EXTRACTED_MODDIR) doesn't match repo listing ($REMOTE_FAMILY), aborting"
  exit 1
fi

log "staging into ${BOOT_STAGE_DIR}..."
mkdir -p "${BOOT_STAGE_DIR}.new"
cp -r "${WORKDIR}/extracted"/* "${BOOT_STAGE_DIR}.new/"

rm -rf "${BOOT_STAGE_DIR}.old"
[[ -d "$BOOT_STAGE_DIR" ]] && mv "$BOOT_STAGE_DIR" "${BOOT_STAGE_DIR}.old"
mv "${BOOT_STAGE_DIR}.new" "$BOOT_STAGE_DIR"
rm -rf "${BOOT_STAGE_DIR}.old"

NEW_VERSION="${REMOTE_FAMILY%%-*}"

log "updating ${KERNEL_NIX} (version=${NEW_VERSION}, modDirVersion=${REMOTE_FAMILY})..."
sed -i \
  -e "s/version = \"[^\"]*\"/version = \"${NEW_VERSION}\"/" \
  -e "s/modDirVersion = \"[^\"]*\"/modDirVersion = \"${REMOTE_FAMILY}\"/" \
  "$KERNEL_NIX"

log "staged ${REMOTE_FAMILY} — will take effect after this rebuild is switched to and the system is rebooted"