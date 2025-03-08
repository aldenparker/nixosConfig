{
  pkgs,
  mkShell,
  ...
}:

# Creates python3 shell with venv (jupyter edition)
mkShell {
  venvDir = ".venv";
  buildInputs = with pkgs; [
    (python3.withPackages (
      ps: with ps; [
        ipython
        jupyter
        numpy
        pandas
        torch
        unidecode
        matplotlib
        jedi-language-server
      ]
    ))
  ];
  packages = with pkgs; [
    python311Packages.venvShellHook
  ];
}
