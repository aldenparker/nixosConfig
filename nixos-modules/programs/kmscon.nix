{
  lib,
  config,
  namespace,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.kmscon; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.kmscon = {
    enable = mkEnableOption "Installs kmscon and configures for nerdfont shells and prompts";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fbterm
    ];

    fonts = {
      packages = with pkgs; [ nerd-fonts.fira-code ];
      fontconfig = {
        enable = true;
	defaultFonts = {
          serif = [ "FiraCode Nerd Font" ];
	  sansSerif = [ "FiraCode Nerd Font" ];
	  monospace = [ "FiraCode Nerf Font Mono" ];
	};
      };  
    };

    services.kmscon = {
      enable = true;
      fonts = [ 
        { 
	  name = "FiraCode Nerd Font Mono"; 
	  package = pkgs.nerd-fonts.fira-code; 
	} 
      ];
      extraConfig = "font-size=11";
      extraOptions = "--term xterm-256color";
    };
  };
}
