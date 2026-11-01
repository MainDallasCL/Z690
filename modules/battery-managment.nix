{
  pkgs, ...
}: {
  # Disable conflicting services
  services.auto-cpufreq.enable = false;
  services.power-profiles-daemon.enable = false; # Conflicts with TLP

  # Thermal management: thermald targets Intel, so it does little on AMD
  services.thermald.enable = false;

  # Kernel: force the amd-pstate EPP driver (Zen 2+).
  # Check first with: cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver
  # If it already says amd-pstate-epp, this is harmless to keep.
  boot.kernelParams = [ "amd_pstate=active" ];

  # TLP - Advanced power management
  services.tlp = {
    enable = true;
    settings = {
      # --- Power/Performance Strategy ---

      # ON AC: Max performance
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      # ON BATTERY: Conservative for lifespan
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # ThinkPad firmware platform profile (Fn+Q equivalent)
      # Verify with: cat /sys/firmware/acpi/platform_profile
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # --- Battery Health ---
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 50;

      # --- Boost control ---
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # --- GPU / runtime PM ---
      # Only meaningful if the laptop has a discrete GPU. On AMD APU-only
      # models these are harmless but do little.
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # --- PCI ---
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersave";

      # --- USB ---
      # TLP only supports USB autosuspend as a single global setting, not per
      # power source. Disabling it also affects battery mode. Remove this line
      # if you want autosuspend on battery.
      USB_AUTOSUSPEND = 1;
    };
  };

  # Battery monitoring
  services.upower.enable = true;

  # Power notification tools
  environment.systemPackages = with pkgs; [
    psi-notify
    poweralertd
  ];
}
