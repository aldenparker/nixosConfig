{ lib, config, pkgs, namespace, ... }:

with lib;

let
  cfg = config.${namespace}.programs.neovim; # Config path
in {
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

          languages = {
            enableLSP = true;
            enableFormat = true;
            enableTreesitter = true;

            nix = {
              enable = true;
            };
          };
        };
      };
    };
  };
}
