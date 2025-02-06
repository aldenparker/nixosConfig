{
  description = "1024bit's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: 
  {
    # --- Set configurations
    nixosConfigurations = {
      mobile-server = nixpkgs.lib.nixosSystem {
        modules = [
          ./profiles/mobile-server/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.msroot = import ./profiles/mobile-server/home.nix;
          }
        ];
      };
    };
  };
}
