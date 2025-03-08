{
  lib,
  inputs,
  ...
}:
{
  numbers = {
    # Simple absolute value functions and modulous for both integers and floats
    abs = n: if n < 0 then -n else n;
    mod = a: b: a - (b * (a / b));
    modFloat =
      let
        modFloat = n: x: if n - x < 0 then n else modFloat (n - x) x;
      in
      modFloat;
  };
}
