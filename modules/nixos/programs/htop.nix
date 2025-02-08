{ lib, config, ... }:

with lib;

let
  module-category = "programs"; # Category the module falls in
  module-name = "htop"; # Name of the module
  cfg = config.snowman.${module-category}.${module-name}; # Config path
in {
  # --- Set options
  options.snowman.${module-category}.${module-name} = {
    enable = mkEnableOption "Enables ${module-name} for host";
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings.show_cpu_temperature = 1;
    };
  };
}
