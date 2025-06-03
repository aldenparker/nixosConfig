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
    enable = mkEnableOption "Configures zed";
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
        "git-firefly"
      ];

      userSettings = {
        # Look and Feel
        icon_theme = "Bearded Icon Theme";
        vim_mode = false;
        base_keymap = "VSCode";
        buffer_font_size = mkForce 13; # Override stylix size
        tab_size = 4;
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
        inlay_hints = {
          enabled = true;
        };

        # Turn off the spyware
        telemetry = {
          metrics = false;
          diagnostics = false;
        };
        features = {
          edit_prediction_provider = "none";
        };
        assistant = {
          enabled = false;
          version = "2";
        };
      };
    };
  };
}
