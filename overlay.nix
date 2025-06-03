{ flake-inputs }:

let
  channel-unstable = flake-inputs.unstable;
in
_final: _prev: rec {
  # Swap to unstable channel
  inherit (channel-unstable) anki;
  inherit (channel-unstable) blender;
  inherit (channel-unstable) bruno;
  inherit (channel-unstable) cloudflared;
  inherit (channel-unstable) glance;
  inherit (channel-unstable) kitty;
  inherit (channel-unstable) ktailctl;
  inherit (channel-unstable) mako;
  inherit (channel-unstable) metasploit;
  inherit (channel-unstable) qemu;
  inherit (channel-unstable) simplex-chat-desktop;
  inherit (channel-unstable) solaar;
  inherit (channel-unstable) waypaper;
  inherit (channel-unstable) zed-editor;

  # Fix nodjs
  nodejs = _prev.nodejs;
  yarn = (_prev.yarn.override { inherit nodejs; });

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
