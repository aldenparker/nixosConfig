{ inputs, lib, config, pkgs, secrets, ... }: {
  imports = [
    # Import generated (nixos-generate-config) hardware configuration
    ../yggdrasil/hardware-configuration.nix

    # Import base NixOS module
    ../../base.nix
  ];

  # --- Setup snowman modules (my custom modules)
  snowman = {
    bundles = {
      audio.enable = true;

      kde = {
        enable = true;
        x11 = false;
      };
      
      bluetooth = {
        enable = true;
        enableAudio = true;
      };
    };

    programs = {
      zsh.enable = true;
      htop.enable = true;
      keymapp.enable = true;
      libreoffice.enable = true;
      steam.enable = true;
      retroarch.enable = true;
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

  # --- Nvidia config for prime (not part of nvidia package as it is super device specific)
  hardware.nvidia.prime = {
    sync.enable = true;

    # Make sure to use the correct Bus ID values for your system!
    nvidiaBusId = "PCI:01:00:0";
    intelBusId = "PCI:00:02:0";
  };

  # --- Packages without configuration
  environment.systemPackages = with pkgs; [
    vscode
    scanmem
    anki
    kicad
    inkscape
    krita
    qbittorrent
    sparrow
    tor-browser
    vlc
    veracrypt
    gephi
    gparted
    ktailctl
    usbimager
    kdePackages.filelight
    anytype
    keepassxc
    simplex-chat-desktop
    solaar
    gittyup
    cutter
  ];

  # --- Enable printing
  services.printing.enable = true;

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
  time.timeZone = "America/Indiana/Indianapolis";

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

