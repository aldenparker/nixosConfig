{ lib, config, pkgs, ... }:

with lib;

let
  module-category = "programs"; # Category the module falls in
  module-name = "neovim"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
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
