{
  description = "High-performance GPU-accelerated image processing for Swift using Metal compute shaders";

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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            swift
            swiftformat
            swiftlint
            yamllint
            pre-commit
          ] ++ lib.optionals stdenv.isDarwin [
            darwin.apple_sdk.frameworks.Metal
            darwin.apple_sdk.frameworks.MetalKit
            darwin.apple_sdk.frameworks.Foundation
          ];

          shellHook = ''
            echo "Swift Metal development environment"
            echo "Swift version: $(swift --version)"
            echo ""
            echo "Available commands:"
            echo "  swift build       - Build the project"
            echo "  swift test        - Run tests"
            echo "  swift run demo    - Run demo"
            echo "  swiftformat .     - Format code"
            echo "  swiftlint         - Lint code"
            echo "  yamllint .        - Lint YAML files"
            echo "  pre-commit run -a - Run all pre-commit hooks"
          '';
        };
      });
}
