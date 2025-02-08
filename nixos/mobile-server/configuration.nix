{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # Import custom modules
    outputs.nixosModules

    # Import generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import base NixOS module
    ../base.nix
  ];

  # --- Setup snowman modules (my custom modules)
  snowman = {
    programs = { 
      zsh.enable = true; 
      htop.enable = true;
    };

    services = {
      glance = {
        enable = true;
        configPath = "/home/msroot/.glance/config.yml";
      };

      tailscale = {
        enable = true;
        isExitNode = true;
      };
    };
  };

  # --- Use the systemd-boot EFI boot loader. WARNING: HERE BE DRAGONS
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking
  networking.hostName = "mobile-server"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable netowrkmanager

  # Enable firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # Lett ssh port through
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # --- User Settings
  # Define the user accounts
  users.users = {
    msroot = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ]; # Enable ‘sudo’ for the user and add netowrk managing
    };
  };

  # ---- NixOS Settings. WARNING: HERE BE DRAGONS
  system.stateVersion = "24.11";

}

