{ channels, ... }:

_final: _prev: {
  inherit (channels.unstable) zig;
  inherit (channels.unstable) zls;
}
