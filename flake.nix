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
	sharedModule = { config, pkgs, ... }:
      {
        _module.args.nixvim-flake = nixvim-flake;
	imports = [./home.nix];
      };

      in {
	homeManagerModules.default = sharedModule;
	homeModule = sharedModule;
      }
    );
}
