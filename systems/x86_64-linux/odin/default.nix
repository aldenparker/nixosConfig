{
  pkgs,
  config,
  secrets,
  ...
}:
{
  imports = [
    # Import generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import base NixOS module
    ../../base.nix
  ];

  # --- Setup snowman modules (my custom modules)
  snowman = {
    bundles = {
      audio.enable = true;
      niri.enable = true;
      cybersecurity.enable = true;

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
      virt-manager = {
        enable = true;
        users = [ "odin" ];
      };
    };

    services = {
      docker.enable = true;

      tailscale = {
        enable = true;
        loginServer = secrets.tailscale.loginServer;
        preAuthKey = secrets.tailscale.preAuthKey;
        operator = "odin";
      };

      cloudflared = {
        enable = true;
        tunnelToken = secrets.cloudflared.odinToken;
      };
    };

    kernelModules = {
      asusWMIScreenpad.enable = true;
    };

    drivers = {
      nvidia = {
        enable = true;
        withCuda = true;
        prime = {
          enable = true;
          useSync = true;

          # Make sure to use the correct Bus ID values for your system!
          nvidiaBusId = "PCI:01:00:0";
          intelBusId = "PCI:00:02:0";
        };
      };
    };
  };

  # --- Drawing Tablet Drivers
  boot.extraModulePackages = [ config.boot.kernelPackages.digimend ];

  # --- Packages without configuration
  environment.systemPackages = with pkgs; [
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
    gnupg
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
    snowman.xnconvert
    snowman.zen
    asus-wmi-screenpad-ctl
    discord
    blender
    audacity
  ];

  # --- Enable printing
  services.printing.enable = true;

  # --- Fix clock for dual boot
  time.hardwareClockInLocalTime = true;

  # --- Use the grub EFI boot loader. WARNING: HERE BE DRAGONS
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # --- Add support for NTFS
  boot.supportedFilesystems = [ "ntfs" ];

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
      "wireshark"
    ]; # Enable ‘sudo’ for the user and add network managing
  };

  # ---- NixOS Settings. WARNING: HERE BE DRAGONS
  system.stateVersion = "24.11";
}
