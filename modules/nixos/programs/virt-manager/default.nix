{
  lib,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.programs.virt-manager; # Config path
in
{
  # --- Set options
  options.${namespace}.programs.virt-manager = {
    enable = mkEnableOption "Installs virt-manager with qemu for host";
    users = mkOption {
      type = types.listOf types.str;
      description = "The users given permision for virtualization";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable necessary options
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = cfg.users;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}
