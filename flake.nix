{
  description = "Elm development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        elmTools = with pkgs; [
          elmPackages.elm
          elmPackages.elm-format
          elmPackages.elm-test
          elmPackages.elm-review
          elmPackages.elm-language-server
          elmPackages.elm-live
        ];

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          python-pptx
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          packages = elmTools ++ [
            pkgs.nodejs_20  # needed for elm-live & editor tooling
            pythonEnv       # Python with python-pptx for create_test_pptx.py
          ];

          shellHook = ''
            echo "🌳 Elm dev environment ready"
            echo "Elm version: $(elm --version)"
            echo "Python version: $(python --version)"
          '';
        };
      }
    );
}

