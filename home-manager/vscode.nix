{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    # Official Microsoft build (default)
    package = pkgs.vscode;

    # Alternatives:
    # package = pkgs.vscodium;          # fully free / no telemetry
    # package = pkgs.vscode.fhs;        # FHS environment (helps many extensions with native binaries)
    # package = pkgs.vscode.fhsWithPackages (ps: with ps; [ /* extra deps */ ]);

    # Optional but highly recommended
    mutableExtensionsDir = false;   # pure / declarative extensions only
    # enableUpdateCheck = false;
    # enableExtensionUpdateCheck = false;

    # Basic settings example
    userSettings = {
      "editor.formatOnSave" = true;
      "editor.tabSize" = 2;
      "files.autoSave" = "afterDelay";
      "workbench.colorTheme" = "Default Dark Modern";
      # "nix.enableLanguageServer" = true;  # if you use nixd / nil
    };

    # Keybindings example
    keybindings = [
      # {
      #   key = "ctrl+shift+t";
      #   command = "workbench.action.terminal.toggleTerminal";
      # }
    ];

    # Extensions (from nixpkgs)
    extensions = with pkgs.vscode-extensions; [
      # Popular ones
      jnoortheen.nix-ide
      # mkhl.direnv
      # ms-python.python
      # rust-lang.rust-analyzer
      github.copilot
      # vscodevim.vim
      # catppuccin.catppuccin-vsc
    ];
  };
}
