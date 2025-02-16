{ inputs, lib, config, pkgs, ... }: {
  # Enable flakes 
  nix.settings.experimental-features = "nix-command flakes"; 

  # Set flake session variable for nh programs
  environment.sessionVariables = {
    FLAKE = "/etc/nixos";
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    jetbrains-mono
  ];

  # --- System Package Settings
  # Must have system packages to get anything done
  environment.systemPackages = with pkgs; [
    nh
    vim
    wget
    curl
    git
    git-crypt
  ];
}
