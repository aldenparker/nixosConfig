{
  lib,
  config,
  pkgs,
  namespace,
  flake-inputs,
  system,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.nushell; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.nushell = {
    enable = mkEnableOption "Configures nushell";
    fastfetch.enable = mkEnableOption "Enables fastfetch for nushell";
    fastfetch.kitty = mkEnableOption "Enables fastfetch to use kitty for image display";
    useAsNixShell = mkEnableOption "Configures nushell as the Nix Shell (aka it us used for nix-shell and nix develop commands)";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install fastfetch for startup if needed and nix-your-shell for nix develop nushell support
    home.packages = [
      (mkIf cfg.useAsNixShell pkgs.nix-your-shell)
      (mkIf cfg.fastfetch.enable pkgs.fastfetch)
    ];

    # --- generate config for nushell
    home.file.".config/nushell/nix-your-shell.nu" = mkIf cfg.useAsNixShell {
      source = pkgs.nix-your-shell.generate-config "nu";
    };

    # --- Nushell config
    programs.nushell = {
      enable = true;
      extraConfig =
        ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell ...$spans | from json
          }

          $env.config = {
            show_banner: false,
            completions: {
              case_sensitive: false # case-sensitive completions
              quick: true    # set to false to prevent auto-selecting completions
              partial: true    # set to false to prevent partial filling of the prompt
              algorithm: "fuzzy"    # prefix or fuzzy
              external: {
                # set to false to prevent nushell looking into $env.PATH to find more suggestions
                enable: true
                # set to lower can improve completion performance at the cost of omitting some options
                max_results: 100
                completer: $carapace_completer # check 'carapace_completer'
              }
            }
          }

          $env.config.plugins.clipboard.NO_DAEMON = true # Add for clipboard plugin to work
        ''
        + (if cfg.useAsNixShell then "\nsource nix-your-shell.nu" else "")
        + (if cfg.fastfetch.enable then "\nfastfetch" else "");

      shellAliases = {
        vim = "neovim";
        nano = "neovim";
        vi = "neovim";
        cat = "bat";
      };

      plugins =
        with pkgs.nushellPlugins;
        with flake-inputs.self.packages.${system};
        [
          units
          semver
          query
          polars
          net
          gstat
          formats
          nu_plugin_clipboard
          nu_plugin_emoji
          nu_plugin_vec
          nu_plugin_desktop_notifications
        ];
    };

    # --- Command Completion
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    # --- Prompt
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$character";
        right_format = "$all"; # Enble one line prompt
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
