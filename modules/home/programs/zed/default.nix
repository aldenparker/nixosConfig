{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.zed; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.zed = {
    enable = mkEnableOption "Installs and configures zed for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "zig"
        "make"
        "html"
        "dockerfile"
        "docker-compose"
        "c#"
        "csv"
        "bearded-icon-theme"
      ];

      # Everything inside of these brackets are Zed options.
      userSettings = {
        # Look and Feel
        icon_theme = "Bearded Icon Theme";
        vim_mode = false;
        base_keymap = "VSCode";
        theme = {
          mode = "system";
          light = "One Light";
          dark = "Gruvbox Dark";
        };
        tab_size = 2;
        ui_font_size = 16;
        buffer_font_size = 13;
        scrollbar = {
          show = "auto";
          cursors = true;
          git_diff = true;
          search_results = true;
          selected_text = false;
          diagnostics = "all";
          axes = {
            horizontal = false;
            vertical = true;
          };
        };

        # Langauge settings
        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter = {
              external = {
                command = "nixfmt";
              };
            };
          };
        };
        lsp = {
          rust-analyzer = {
            binary = {
              path_lookup = true;
            };
          };
        };

        # Turn off the spyware
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
        features = {
          inline_completion_provider = "none";
        };
        assistant = {
          enabled = false;
          version = "2";
        };
      };
    };
  };
}
