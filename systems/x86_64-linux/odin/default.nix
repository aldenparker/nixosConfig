{ inputs, lib, config, pkgs, secrets, ... }: {
  imports = [
    # Import generated (nixos-generate-config) hardware configuration
    ../yggdrasil/hardware-configuration.nix

    # Import base NixOS module
    ../../base.nix
  ];

  # --- Stylix Theme
  stylix = {
    enable = true;
    image = ./wizards-journey.jpg; # Required for some reason, does not set wallpaper
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };

  # --- Setup snowman modules (my custom modules)
  snowman = {
    bundles = {
      audio.enable = true;
      bluetooth = {
        enable = true;
        enableAudio = true;
      };
    };

    programs = {
      zsh.enable = true;
      htop.enable = true;
      keymapp.enable = true;
      #hyprland.enable = true;
    };

    services = {
      podman.enable = true;

      tailscale = {
        enable = true;
        isExitNode = true;
        loginServer = secrets.tailscale.loginServer;
        preAuthKey = secrets.tailscale.preAuthKey;
      };
    };

    kernelModules = {
      asusWMIScreenpad.enable = true;
    };

    drivers = {
      cuda.enable = true;
    };
  };

  hardware.nvidia.prime = {
    sync.enable = true;

    # Make sure to use the correct Bus ID values for your system!
    nvidiaBusId = "PCI:01:00.0";
    intelBusId = "PCI:00:02.0";
  };

  # --- Use the grub EFI boot loader. WARNING: HERE BE DRAGONS
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # --- Networking
  networking = {
    hostName = "odin"; # Define your hostname.
    networkmanager.enable = true; # Enable networkmanager

    # Enable firewall
    firewall.enable = true;
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

  # --- User Settings
  # Define the user accounts
  users.users.odin = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]; # Enable ‘sudo’ for the user and add network managing
  };

  # ---- NixOS Settings. WARNING: HERE BE DRAGONS
  system.stateVersion = "24.11";
}

