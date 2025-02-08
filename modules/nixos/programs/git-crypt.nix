{ lib, config, pkgs, ... }:

with lib;

let
  module-type = "nx"; # home-manager (hm) vs nixos (nx)
  module-category =
    "programs"; # category the module falls in, usually the name of the folder it is in
  module-name = "git-crypt"; # Name of the module
in {
  # --- Set options
  options.snowman.${module-type}.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf
    config.snowman.${module-type}.${module-category}.${module-name}.enable {
      environment.systemPackages = [ pkgs.git-crypt ];
    };
}
