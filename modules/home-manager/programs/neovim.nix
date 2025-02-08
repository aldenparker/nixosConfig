{ lib, config, pkgs, ... }:

with lib;

{
  # --- Set options
  options = {
    enable = mkEnableOption "Enables Neovim for host";
  };

  # --- Set configuration
  config = mkIf config.enable {
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
            };

            # Setup basic needs
            statusline.lualine.enable = true;
            telescope.enable = true;
            autocomplete.nvim-cmp.enable = true;

            languages = {
              enableLSP = true;
              enableTreesitter = true;

              nix.enable = true;
            };
          };
        };
      };
    };
}
