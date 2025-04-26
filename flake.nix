{
  description = "My cross platform nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-flake.url = "github:n4226/nixvimConfig";
  };

  outputs = { self, nixpkgs, nix-darwin, flake-utils, nixvim-flake, home-manager }:
    let
      hostPlatform = "aarch64-darwin";
      sharedModule = { config, pkgs, ... }:
	{
	  _module.args.nixvim-flake = nixvim-flake;
	  imports = [./home.nix];
	};
    in {
      homeManagerModules = flake-utils.lib.eachDefaultSystem (system:
	let
	  pkgs = import nixpkgs { inherit system; };

	in {
	  homeManagerModules.default = sharedModule;
	  homeModule = sharedModule;
	}
      );

      darwinConfigurations = {
	"MBP_M1" = nix-darwin.lib.darwinSystem {
	  system = hostPlatform;
	  modules = [
	    ./darwin-config/darwin.nix
	    home-manager.darwinModules.home-manager
	  ];
	  specialArgs = {
	    inherit home-manager;
	    my-home-module = sharedModule; 
	    self-flake = self;
	    username = "michaelbaron";
	    system = hostPlatform;
	  };
	};

	"MacBook-Pro-2886" = self.darwinConfigurations."MBP_M1"; # reuse config if you want
      };

      darwinPackages = self.darwinConfigurations."MBP_M1".pkgs;

    };
}
