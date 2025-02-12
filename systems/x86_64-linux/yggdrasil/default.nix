{ inputs, lib, config, pkgs, secrets, ... }: {
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
      podman.enable = true;

      glance = {
        enable = true;
        configPath = "/home/yggdrasil/.glance/config.yml";
        port = 80;
      };

      filebrowser = {
        enable = true;
        port = 8001;
        dataPath = "/mnt/data/filebrowser";
      };

      tailscale = {
        enable = true;
        isExitNode = true;
        loginServer = secrets.tailscale.loginServer;
        preAuthKey = secrets.tailscale.preAuthKey;
      };

      postgres = {
        enable = true;
        dataPath = "/mnt/data/postgres";
      };

      gitea = {
        enable = true;
        siteName = "SheltieVCS";
        domain = "yggdrasil.headscale.com";
        port = 8000;
        passwordFile = "/mnt/data/gitea/.db-password";
        dataPath = "/mnt/data/gitea/state";
        runnerToken = secrets.gitea.runnerToken;
      };
    };
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
  networking.hostName = "yggdrasil"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networkmanager

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

  # ---- NixOS Settings. WARNING: HERE BE DRAGONS
  system.stateVersion = "24.11";

}

