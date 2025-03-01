{ channels, ... }: 

_final: _prev: rec
{
  nodejs = _prev.nodejs;
  yarn = (_prev.yarn.override { inherit nodejs; });
}
