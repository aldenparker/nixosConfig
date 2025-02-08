{
  description = "1024bit's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nvf, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
    in {
      # --- Set formatter
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      # --- Set configurations
      nixosConfigurations = {
        mobile-server = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit secrets; };
          modules = [
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ overlay-unstable ];
            })
            ./hosts/mobile-server/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.msroot = import ./hosts/mobile-server/home.nix;
              home-manager.extraSpecialArgs = {
                inherit nvf;
                inherit secrets;
              };
            }
          ];
        };
      };
    };
}
