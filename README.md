# SNOWMAN
Welcome to my nixOS configuration. The premise behind the "snowman" architecture is that all modules are loaded in by the flake and then all custom modules are configured under the snowman namespace. The file structure goes like this:

```
/
  flake.nix
  flake.lock
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
```

In this way, services and programs can get their own modules, but predefined configuration of many modules can be loaded through bundles. NO MODULES SHOULD LOAD AUTOMATICALLY. Every module should have an enable option.:
