{ unstable-channel }:

_final: _prev: rec {
  # Swap to unstable channel
  inherit (unstable-channel) anki;
  inherit (unstable-channel) blender;
  inherit (unstable-channel) bruno;
  inherit (unstable-channel) cloudflared;
  inherit (unstable-channel) glance;
  inherit (unstable-channel) kitty;
  inherit (unstable-channel) ktailctl;
  inherit (unstable-channel) mako;
  inherit (unstable-channel) metasploit;
  inherit (unstable-channel) qemu;
  inherit (unstable-channel) simplex-chat-desktop;
  inherit (unstable-channel) solaar;
  inherit (unstable-channel) waypaper;

  # Fix nodjs
  nodejs = _prev.nodejs;
  yarn = (_prev.yarn.override { inherit nodejs; });

  # Fix wlogout by adding svg capability
  wlogout = _prev.wlogout.overrideAttrs (
    finalAttrs: previousAttrs: {
      buildInputs = previousAttrs.buildInputs ++ [
        _prev.librsvg
      ];
    }
  );

  # Build rust toolchain
  rustToolchain =
    let
      rust = _prev.rust-bin;
    in
    if builtins.pathExists ./rust-toolchain.toml then
      rust.fromRustupToolchainFile ./rust-toolchain.toml
    else if builtins.pathExists ./rust-toolchain then
      rust.fromRustupToolchainFile ./rust-toolchain
    else
      rust.stable.latest.default.override {
        extensions = [
          "rust-src"
          "rustfmt"
        ];
      };
}
