{ lib, config, ... }:

with lib;

let
  module-type = ""; # home-manager (hm) vs nixos (nx)
  module-category = ""; # category the module falls in, usually the name of the folder it is in
  module-name = ""; # Name of the module
in {
  # --- Set options
  options.snowman.${module-type}.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf config.snowman.${module-type}.${module-category}.${module-name}.enable {
  
  };
}
