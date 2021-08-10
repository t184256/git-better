{
  # TODO: set meaningful description
  description = "TODO";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          # TODO: replace project-name with a dashed project name
          project-name = pkgs.python3Packages.buildPythonPackage {
            pname = "project-name";  # TODO: replace
            version = "0.0.1";
            src = ./.;
            propagatedBuildInputs = with pkgs.python3Packages; [
              # TODO: list python dependencies
            ];
            checkInputs = with pkgs.python3Packages; [
              pytest
              coverage
              flake8
              flake8-import-order
              codespell
            ] ++ [ pkgs.gnumake ];
            checkPhase = "make check";
          };
        in
        {
          packages.project-name = project-name;  # TODO: replace
          defaultPackage = project-name;  # TODO: replace
          apps.project-name = flake-utils.lib.mkApp { drv = project-name; }; # TODO: replace
          defaultApp = project-name;  # TODO: replace
          devShell = import ./shell.nix { inherit pkgs; };
        }
      );
}
