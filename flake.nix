{
  description = "My cross platform nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim-flake.url = "github:n4226/nixvimConfig";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim-flake, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
	sharedModule = import ./home.nix { inherit pkgs nixvim-flake; };
      in {
	homeManagerModules.default = sharedModule;
	packages.default = pkgs.writeText "noop-home-config" ''
        This flake is only for home-manager modules.
        Nothing to build.
      '';
      }
    );
}
