{
  pkgs,
  secrets,
  ...
}:
{
  # This is the config for RPI 3B+ tailscale exit nodes, hence heimdallur as a reference to the bifrost
  imports = [
    # Import generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import base NixOS module
    ../../base.nix
  ];

  # --- Setup snowman modules (my custom modules)
  snowman = {
    programs = {
      zsh.enable = true;
      htop.enable = true;
    };

    services = {
      tailscale = {
        enable = true;
        isExitNode = true;
        loginServer = secrets.tailscale.loginServer;
        preAuthKey = secrets.tailscale.preAuthKey;
      };
    };
  };

  # --- Use the grub EFI boot loader. WARNING: HERE BE DRAGONS
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # --- Networking
  networking.hostName = "heimdallur"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable netowrkmanager

  # Enable firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # Let ssh port through
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no"; # Forbid root login through SSH for security.
    };
  };

  # Publish hostname to local network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # --- Localization Codes
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # --- RPI Specific
  hardware.enableRedistributableFirmware = true;

  # --- User Settings
  users.users = {
    heimdallur = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ]; # Enable ‘sudo’ for the user and add network managing
    };
  };

  # --- NixOS Settings. WARNING: HERE BE DRAGONS
  system.stateVersion = "25.05";

}
