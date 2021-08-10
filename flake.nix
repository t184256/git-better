{
  description = "A set of opinionated git wrappers";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          git-better = pkgs.python3Packages.buildPythonPackage {
            pname = "git-better";
            version = "0.0.1";
            src = ./.;
            propagatedBuildInputs = with pkgs.python3Packages; [
              GitPython
            ];
            checkInputs = (with pkgs.python3Packages; [
              pytest
              pytest-mock
              coverage
              flake8
              flake8-import-order
              codespell
            ]) ++ (with pkgs; [
              bash
              git
              gnumake
              libfaketime
            ]);
            checkPhase = "make check";
          };
        in
        {
          packages.git-better = git-better;
          defaultPackage = git-better;
          apps.git-better = flake-utils.lib.mkApp { drv = git-better; };
          defaultApp = git-better;
          devShell = import ./shell.nix { inherit pkgs; };
        }
      );
}
