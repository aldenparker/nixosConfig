# SNOWMAN
Welcome to my nixOS configuration. The reason behind the name, "snowman" is because it is a structured (snow)flake used to manage all of my machines. The structure relys on nixos and home-manager at the core, so you need to use both of these to get the entire value.
Below is a quick overview of the file structure:


```
/
  flake.nix
  flake.lock
  secrets.json
  templates/ # Templates used for making new nix files
    module.nix
    ...
  modules/
    default.nix
    nixos/
      default.nix
      packages/ # Individual packages with base configuration
        pkg-module.nix
        ...
      bundles/ # Bundles of multiple packages and services
        bundle-module.nix
        ...
      services/ # Non user facing services or platforms
        service-module.nix
        ...
    home-manager/
      default.nix
      packages/
        pkg-module.nix
        ...
      bundles/
        bundle-module.nix
        ...
      services/
        service-module.nix
        ...
  nixos/
    base.nix # Base configuration I use for all my machines
    hostname/
      configuration.nix
      hardware-configuration.nix
    ...
  home-manager/
    base.nix # Base configuration I use for all of my users
    user/
      home.nix
      ...
    ...
  pkgs/ # Custom built packages
    ...
  overlays/ # Overlays for existing repos
    ...
```

## Secrets
The flake uses ```git-crypt``` and a ```secrets.json``` to hold secrets like a github auth token or the auth token and server url for tailscale. 

## Modules
### git
A home manager module that installs git and auto sets up my user details. It is also set to store credentials, but an access key will be needed on first authentification.
```snowman.programs.git.enable = true;```

### nvim
A home manager module that uses the nfv flake to setup nvim for nix coding.
```snowman.programs.nvim.enable = true;```

### zsh
A home manager and nixos module that is used to setup zsh with basic features and aliases for nixos. The nixos module makes zsh the default use shell while the home manager one sets up the config.

The below command goes in both the configuration and home files.
```snowman.programs.zsh.enable = true;```

### tailscale
A nixos module that enables tailscale and has some options for configuring the firewall based on tailscale. Authentication will still need to be done the first time with ```sudo tailscale up``` command and all that entails.
```
snowman.services.tailscale = {
  enable = true;
  isExitNode = true; # To make it an exit node
}
```

### glance
A nixos module that adds a glance homepage instance to the host.
```
snoman.services.glance = {
  enable = true;
  configPath = ""; # Path to config file
}
```

### htop
A nixos modules for installing and configuring htop.
```snowman.programs.htop.enable = true;```
