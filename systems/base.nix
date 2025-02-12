{ inputs, lib, config, pkgs, ... }: {
  # Enable flakes 
  nix.settings.experimental-features = "nix-command flakes"; 

  # --- System Package Settings
  # Must have system packages to get anything done
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    git-crypt
    snowfallorg.flake
  ];
}
