{ channels, ... }: 

_final: _prev:
{
  inherit (channels.unstable) hyprland;
  inherit (channels.unstable) waypaper;
}
