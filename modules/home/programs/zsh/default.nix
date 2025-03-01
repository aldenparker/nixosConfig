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
    enable = mkEnableOption "Configures zsh for host";
    fastfetch.enable = mkEnableOption "Configures fastfetch for host";
    fastfetch.kitty = mkEnableOption "Configures fastfetch with kitty image for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Install neofetch for startup
    home.packages = mkIf cfg.fastfetch.enable [ pkgs.fastfetch ];

    # Configure zsh, must enable nixos package version as well for default shell behavior
    programs.zsh = {
      # Basic Config values
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = "fastfetch"; # fastfetch runs on terminal startup

      # Enable oh-my-zsh
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    };

    # Copy fastfetch config files
    home.file.".config/fastfetch/nixos-icon.png" = mkIf cfg.fastfetch.kitty {
      source = ./nixos-icon.png;
    };

    home.file.".config/fastfetch/config.jsonc" = mkIf cfg.fastfetch.enable {
      text = ''
        {
          "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
          "logo": {
            "type": "${(if cfg.fastfetch.kitty then "kitty" else "builtin")}",
            ${(if cfg.fastfetch.kitty then "\"source\": \"~/.config/fastfetch/nixos-icon.png\"," else "")}
            "height": 10,
            "width": 25,
            "padding": {
              "top": ${(if cfg.fastfetch.kitty then "1" else "0")},
              "left": ${(if cfg.fastfetch.kitty then "3" else "0")}
            }
          },
          "modules": [
            "break",
            {
              "type": "custom",
              "format": "\u001b[90m┌──────────────────────Hardware──────────────────────┐"
            },
            {
              "type": "host",
              "key": " PC",
              "keyColor": "green"
            },
            {
              "type": "cpu",
              "key": "│ ├",
              "keyColor": "green"
            },
            {
              "type": "gpu",
              "key": "└ └",
              "keyColor": "green"
            },
            {
              "type": "custom",
              "format": "\u001b[90m└────────────────────────────────────────────────────┘"
            },
            "break",
            {
              "type": "custom",
              "format": "\u001b[90m┌────────────────Uptime / Age / DT────────────────┐"
            },
            {
              "type": "command",
              "key": "  OS Age ",
              "keyColor": "magenta",
              "text": "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days"
            },
           {
              "type": "uptime",
              "key": "  Uptime ",
              "keyColor": "magenta"
            },
            {
              "type": "datetime",
              "key": "  DateTime ",
              "keyColor": "magenta"
            },
            {
              "type": "custom",
              "format": "\u001b[90m└─────────────────────────────────────────────────┘"
            },
            "break"
          ]
        }
      '';
    };
  };
}
