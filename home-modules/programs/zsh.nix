{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.zsh; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.zsh = {
    enable = mkEnableOption "Configures zsh";
    fastfetch.enable = mkEnableOption "Enables fastfetch for zsh";
    fastfetch.kitty = mkEnableOption "Enables fastfetch to use kitty for image display";
    useAsNixShell = mkEnableOption "Configures zsh as the Nix Shell (aka it us used for nix-shell and nix develop commands)";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install fastfetch for startup if needed and nix-your-shell for nix develop zsh support
    home.packages = [
      (mkIf cfg.useAsNixShell pkgs.nix-your-shell)
      (mkIf cfg.fastfetch.enable pkgs.fastfetch)
    ];

    # Configure zsh, must enable nixos package version as well for default shell behavior
    programs.zsh = {
      # Basic Config values
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Fastfetch runs on terminal startup
      initContent =
        ""
        + (if cfg.useAsNixShell then "\nnix-your-shell zsh | source /dev/stdin" else "")
        + (if cfg.fastfetch.enable then "\nfastfetch" else "");

      # Enable oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    };

    # --- Fastfetch config
    home.file.".config/fastfetch/nixos-icon.png" = mkIf cfg.fastfetch.kitty {
      source = ../../assets/nixos-icon.png;
    };

    programs.fastfetch = {
      enable = cfg.fastfetch.enable;
      settings = {
        logo = {
          type = (if cfg.fastfetch.kitty then "kitty" else "builtin");
          source = mkIf cfg.fastfetch.kitty "~/.config/fastfetch/nixos-icon.png";
          height = 10;
          width = 25;
          padding = {
            top = (if cfg.fastfetch.kitty then 1 else 0);
            left = (if cfg.fastfetch.kitty then 3 else 0);
          };
        };
        modules = [
          "break"
          {
            type = "custom";
            format = "\u001b[90m┌──────────────────────Hardware──────────────────────┐";
          }
          {
            type = "host";
            key = " PC";
            keyColor = "green";
          }
          {
            type = "cpu";
            key = "│ ├";
            keyColor = "green";
          }
          {
            type = "gpu";
            key = "└ └";
            keyColor = "green";
          }
          {
            type = "custom";
            format = "\u001b[90m└────────────────────────────────────────────────────┘";
          }
          "break"
          {
            type = "custom";
            format = "\u001b[90m┌────────────────Uptime / Age / DT────────────────┐";
          }
          {
            type = "command";
            key = "  OS Age ";
            keyColor = "magenta";
            text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          }
          {
            type = "uptime";
            key = "  Uptime ";
            keyColor = "magenta";
          }
          {
            type = "datetime";
            key = "  DateTime ";
            keyColor = "magenta";
          }
          {
            type = "custom";
            format = "\u001b[90m└─────────────────────────────────────────────────┘";
          }
          "break"
        ];
      };
    };
  };
}
