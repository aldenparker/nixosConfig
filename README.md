# SNOWMAN
Welcome to my nixOS configuration. The premise behind the "snowman" architecture is that all modules are loaded in by the flake and then all custom modules are configured under the snowman namespace. The file structure goes like this:

```
/
  flake.nix
  flake.lock
  secrets.json
  templates/
    module.nix
    ...
  modules/
    default.nix
    nixos/
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
      overlays/
        overlay-module.nix
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
      overlays/
        overlay-module.nix
        ...
  hosts/
    hostname/
      configuration.nix
      hardware-configuration.nix
      home.nix
    ...
```

In this way, services and programs can get their own modules, but predefined configuration of many modules can be loaded through bundles. NO MODULES SHOULD LOAD AUTOMATICALLY. Every module should have an enable option.
There is also a templates folder holding templates for the how different nix files in this structure.

## Secrets
The flake uses ```git-crypt``` and a ```secrets.json``` to hold secrets like a github auth token or the auth token and server url for tailscale. 

## Modules
### git
A home manager module that installs git and auto sets up my user details. It is also set to store credentials, but an access key will be needed on first authentification.
```snowman.hm.programs.git.enable = true;```

### nvim
A home manager module that uses the nfv flake to setup nvim for nix coding.
```snowman.hm.programs.nvim.enable = true;```

### zsh
A home manager and nixos module that is used to setup zsh with basic features and aliases for nixos. The nixos module makes zsh the default use shell while the home manager one sets up the config.
```snowman.hm.programs.zsh.enable = true;```
```snowman.nx.programs.zsh.enable = true;```

### tailscale
A nixos module that enables tailscale and has some options for configuring the firewall based on tailscale. Authentication will still need to be done the first time with ```sudo tailscale up``` command and all that entails.
```
snowman.nx.services.tailscale = {
  enable = true;
  isExitNode = true; # To make it an exit node
}
```

