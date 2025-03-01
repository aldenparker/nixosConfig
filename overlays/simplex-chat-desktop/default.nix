{ channels, ... }: 

_final: _prev:
{
  inherit (channels.unstable) simplex-chat-desktop;
}
