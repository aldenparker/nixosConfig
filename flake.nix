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
      # --- Config Values
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
      ]; # All external overlays to be applied to pkgs (used for createPkgs and config for normal nixos)

      nixos-modules = [
        niri.nixosModules.niri
        ./nixos-config
        ./nixos-modules
      ]; # Nixos modules to load

      home-modules = [
        stylix.homeModules.stylix
        ./home-config
        ./home-modules
      ]; # Home manager modules to load

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ]; # List of systems that I have configs for (generated needed variables)

      # --- Creation Functions
      createForEachSystem =
        createFunc:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = createFunc { inherit system; };
          }) systems
        );

      createPkgs =
        { system }:
        import nixpkgs {
          inherit system;
          config = pkg-config;
          overlays = pkg-overlays ++ [
            (import ./overlay.nix { unstable-channel = inputs.unstable.legacyPackages.${system}; })
          ];
        }; # Used to keep consitent package config

      createHomeSpecialArgs =
        {
          system,
          withPkgs ? true,
        }:
        {
          inherit system;
          inherit secrets;
          inherit namespace;
          flake-inputs = inputs;
        }
        // (
          if withPkgs then
            {
              pkgs = createPkgs { inherit system; };
            }
          else
            { }
        );

      createNixosSpecialArgs =
        { system }:
        {
          inherit pkg-config;
          inherit pkg-overlays;
        }
        // createHomeSpecialArgs {
          inherit system;
          withPkgs = false;
        };

      createPackages =
        { system }:
        import ./packages/${system}.nix {
          pkgs = pkgs.${system};
        }; # Import packages for system

      createDevShells =
        { system }:
        import ./shells/${system}.nix {
          inherit system;
          pkgs = pkgs.${system};
          flake-inputs = inputs;
        }; # Import devshells for system

      # --- Built Vairables
      nixos-special-args = createForEachSystem createNixosSpecialArgs;
      home-special-args = createForEachSystem createHomeSpecialArgs;
      pkgs = createForEachSystem createPkgs;
    in
    {
      nixosConfigurations = {
        # --- x86_64-linux ---
        odin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs.x86_64-linux;
          specialArgs = nixos-special-args.x86_64-linux;
          modules = nixos-modules ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = home-special-args.x86_64-linux;
              home-manager.users.odin.imports = home-modules ++ [
                ./home-config/x86_64-linux/odin-odin
              ];
            }
            ./nixos-config/x86_64-linux/odin
          ];
        };

        yggdrasil = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgs.x86_64-linux;
          specialArgs = nixos-special-args.x86_64-linux;
          modules = nixos-modules ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = home-special-args.x86_64-linux;
              home-manager.users.yggdrasil.imports = home-modules ++ [
                ./home-config/x86_64-linux/yggdrasil-yggdrasil
              ];
            }
            ./nixos-config/x86_64-linux/yggdrasil
          ];
        };

        # --- aarch64-linux ---
        heimdallur = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          pkgs = pkgs.aarch64-linux;
          specialArgs = nixos-special-args.aarch64-linux;
          modules = nixos-modules ++ [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = home-special-args.aarch64-linux;
              home-manager.users.heimdallur.imports = home-modules ++ [
                ./home-config/aarch64-linux/heimdallur-heimdallur
              ];
            }
            ./nixos-config/aarch64-linux/heimdallur
            nixos-hardware.nixosModules.raspberry-pi-3
          ];
        };
      };

      packages = createForEachSystem createPackages;

      devShells = createForEachSystem createDevShells;
    };
}
