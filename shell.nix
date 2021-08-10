{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # TODO: add generic dependencies
    (python3.withPackages (ps: with ps; [
      # TODO: add python dependencies
    ]))
  ];
  nativeBuildInputs = with pkgs.python3Packages; [
    pytest
    coverage
    flake8
    flake8-import-order
    codespell
  ] ++ [ pkgs.gnumake ];
}
