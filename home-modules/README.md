# A note on the use of home manager

The philosophy here is to first and foremost use a home manager module if it exists. If not, fall back to either linking a config file with `home.file` (in the case no dynamic elements are needed), or creating dynamic configs using `home.file.[NAME].text`. These modules *SHOULD NOT* install any new pakages. They should only be used to configure any packages installed by the nixos system.

The only time programs can be installed using these modules is when those programs are addons to or extend the functionality of whatever the module configures. An example is the `zsh` module, which conditionally installs `fastfetch` and `nix-your-shell` when asked for.
