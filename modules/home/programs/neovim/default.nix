{
  lib,
  config,
  namespace,
  inputs,
  system,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.neovim; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.neovim = {
    enable = mkEnableOption "Installs and configures neovim for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Uses nvf to install and configure neovim
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          # Set tab size
          options = {
            tabstop = 2;
            shiftwidth = 2;
            clipboard = "unnamedplus";
          };

          # Setup aliases
          viAlias = false;
          vimAlias = true;

          # Setup theme
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";

            # Add extra lua to run
            extraConfig = ''
              vim.diagnostic.config({ update_in_insert = true })
            '';
          };

          # Setup basic needs
          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;

          # Setup filetree
          filetree = {
            nvimTree = {
              enable = true;
              openOnSetup = true;

              mappings = {
                toggle = "<C-w>";
              };

              setupOpts = {
                disable_netrw = true;
                update_focused_file.enable = true;

                hijack_unnamed_buffer_when_opening = true;
                hijack_cursor = true;
                hijack_directories = {
                  enable = true;
                  auto_open = true;
                };

                git = {
                  enable = true;
                  show_on_dirs = false;
                  timeout = 500;
                };

                view = {
                  cursorline = false;
                  width = 15;
                };

                renderer = {
                  indent_markers.enable = true;
                  root_folder_label = false; # inconsistent

                  icons = {
                    modified_placement = "after";
                    git_placement = "after";
                    show.git = true;
                    show.modified = true;
                  };
                };

                diagnostics.enable = true;

                modified = {
                  enable = true;
                  show_on_dirs = false;
                  show_on_open_dirs = true;
                };

                actions = {
                  change_dir.enable = false;
                  change_dir.global = false;
                  open_file.window_picker.enable = true;
                };
              };
            };
          };

          # Language support
          languages = {
            enableLSP = true;
            enableFormat = true;
            enableTreesitter = true;

            nix = {
              enable = true;
            };

            zig = {
              enable = true;
              lsp = {
                package = inputs.zls-overlay.packages.${system}.zls;
              };
            };
          };
        };
      };
    };
  };
}
