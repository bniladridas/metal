{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    swift
    swiftformat
    swiftlint
    yamllint
    pre-commit
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.apple_sdk.frameworks.Metal
    pkgs.darwin.apple_sdk.frameworks.MetalKit
    pkgs.darwin.apple_sdk.frameworks.Foundation
  ];
}
