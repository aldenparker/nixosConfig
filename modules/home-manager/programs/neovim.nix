{ lib, config, pkgs, ... }:

with lib;

let
  module-type = "hm"; # home-manager (hm) vs nixos (nx)
  module-category =
    "programs"; # category the module falls in, usually the name of the folder it is in
  module-name = "neovim"; # Name of the module
in {
  # --- Set options
  options.snowman.${module-type}.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf
    config.snowman.${module-type}.${module-category}.${module-name}.enable {
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
