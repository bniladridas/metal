{
  description = "Metal image processing experiments and research";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.research = pkgs.mkShell {
          buildInputs = with pkgs; [
            swift
            python3
            jupyter
            matplotlib
            numpy
          ] ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Metal
            darwin.apple_sdk.frameworks.MetalKit
            darwin.apple_sdk.frameworks.Accelerate
          ];

          shellHook = ''
            echo "Metal Research Environment"
            echo "Available tools:"
            echo "  swift         - Swift compiler"
            echo "  python3       - Python for analysis"
            echo "  jupyter       - Jupyter notebooks"
          '';
        };
      });
}
