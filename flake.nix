{
  description = "aldenparker's dotfiles";

  inputs = {
    # --- PACKAGE CHANNELS ---
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- HARDWARE FLAKES ---
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # Hardware Configurations
    asus-wmi-screenpad-ctl.url = "github:aldenparker/asus-wmi-screenpad-ctl"; # ASUS-WMI-SCREENPAD control utility

    asus-wmi-screenpad = {
      url = "github:MatthewCash/asus-wmi-screenpad-module";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # ASUS-WMI-SCREENPAD driver

    # --- NIX ADDONS ---
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Configures and manages dotfiles

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Styles entire system

    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Helps with adding zsh support in nix shells and nix develop

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Provides newest version of rust

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Provides newest version of zig

    zls-overlay = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig-overlay";
    }; # Provides newest version of zls

    # --- PROGRAMS ---
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    }; # Newest version of niri desktop

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
    }; # Newest version of zen browser
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      nixos-hardware,
      niri,
      nix-your-shell,
      rust-overlay,
      asus-wmi-screenpad-ctl,
      stylix,
      ...
    }@inputs:

    let
      secrets = builtins.fromJSON (builtins.readFile "${inputs.self}/secrets.json"); # Import all secrets for configs
      namespace = "snowman"; # Used to put all custom config options in one place

      pkg-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      }; # The config options for nixpkgs

      pkg-overlays = [
        nix-your-shell.overlays.default
        rust-overlay.overlays.default
        niri.overlays.niri
        (import ./overlay.nix { flake-inputs = inputs; })
      ]; # All overlays to be applied to pkgs (used for createPkgs and config for normal nixos)

      createPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = pkg-config;
          overlays = pkg-overlays;
        }; # Used to keep consitent package config

      pkgs-x86_64-linux = createPkgs "x86_64-linux";
      pkgs-aarch64-linux = createPkgs "aarch64-linux";

      nixos-modules = [
        niri.nixosModules.niri
        ./nixos-config
        ./nixos-modules
      ];

      home-modules = [
        niri.homeModules.niri
        stylix.homeModules.stylix
        ./home-config
        ./home-modules
      ];
    in
    {
      nixosConfigurations = {
        # --- x86_64-linux ---
        odin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = nixos-modules ++ [
            ./nixos-config/x86_64-linux/odin
          ];

          specialArgs = {
            system = "x86_64-linux";
            inherit secrets;
            inherit pkg-config;
            inherit pkg-overlays;
            inherit namespace;
            flake-inputs = inputs;
          };
        };

        yggdrasil = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = nixos-modules ++ [
            ./nixos-config/x86_64-linux/yggdrasil
          ];

          specialArgs = {
            system = "x86_64-linux";
            inherit secrets;
            inherit pkg-config;
            inherit pkg-overlays;
            inherit namespace;
            flake-inputs = inputs;
          };
        };

        # --- aarch64-linux ---
        heimdallur = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = nixos-modules ++ [
            ./nixos-config/aarch64-linux/heimdallur
            nixos-hardware.nixosModules.raspberry-pi-3
          ];

          specialArgs = {
            system = "aarch64-linux";
            inherit secrets;
            inherit pkg-config;
            inherit pkg-overlays;
            inherit namespace;
            flake-inputs = inputs;
          };
        };
      };

      homeConfigurations = {
        # --- x86_64-linux ---
        "odin@odin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = home-modules ++ [
            ./home-config/x86_64-linux/odin-odin
          ];

          extraSpecialArgs = {
            system = "x86_64-linux";
            inherit secrets;
            inherit namespace;
            flake-inputs = inputs;
          };
        };

        "yggdrasil@yggdrasil" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs-x86_64-linux;
          modules = home-modules ++ [
            ./home-config/x86_64-linux/yggdrasil-yggdrasil
          ];

          extraSpecialArgs = {
            system = "x86_64-linux";
            inherit secrets;
            inherit namespace;
            flake-inputs = inputs;
          };
        };

        # --- aarch64-linux ---
        "heimdallur@heimdallur" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs-aarch64-linux;
          modules = home-modules ++ [
            ./home-config/aarch64-linux/heimdallur-heimdallur
          ];

          extraSpecialArgs = {
            system = "aarch64-linux";
            inherit secrets;
            inherit namespace;
            flake-inputs = inputs;
          };
        };
      };

      packages = {
        x86_64-linux = import ./packages/x86_64-linux.nix {
          pkgs = pkgs-x86_64-linux;
        };

        aarch64-linux = import ./packages/aarch64-linux.nix {
          pkgs = pkgs-aarch64-linux;
        };
      };

      devShells = {
        x86_64-linux = import ./shells/x86_64-linux.nix {
          system = "x86_64-linux";
          pkgs = pkgs-x86_64-linux;
          flake-inputs = inputs;
        };

        aarch64-linux = import ./shells/aarch64-linux.nix {
          system = "aarch64-linux";
          pkgs = pkgs-aarch64-linux;
          flake-inputs = inputs;
        };
      };
    };
}
