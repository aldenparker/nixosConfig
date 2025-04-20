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
        torchvision
        unidecode
        matplotlib
        jedi-language-server
        seaborn
        scipy
        scikit-learn
        torchsummary
      ]
    ))
  ];
  packages = with pkgs; [
    python311Packages.venvShellHook
  ];
}
