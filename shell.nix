{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    (python3.withPackages (ps: with ps; [
      GitPython
    ]))
  ];
  nativeBuildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [
      GitPython
      pytest
      pytest-mock
    ]))
  ] ++ (with pkgs.python3Packages; [
    coverage
    flake8
    flake8-import-order
    codespell
  ]) ++ (with pkgs; [
    git
    gnumake
  ]);
}
