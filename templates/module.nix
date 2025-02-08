{ lib, config, ... }:

with lib;

let
  module-category = ""; # Category the module falls in
  module-name = ""; # Name of the module
in {
  # --- Set options
  options.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf config.${module-category}.${module-name}.enable { };
}
