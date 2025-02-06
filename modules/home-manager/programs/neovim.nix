{ lib, config, pkgs, ... }:

with lib;

let 
  cfg = config.snowman.hm.programs.neovim;
in {
  options.snowman.hm.programs.neovim.enable = mkEnableOption "Enables Neovim for host";

  # --- Simple setup for Neovim using nvf
  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
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
