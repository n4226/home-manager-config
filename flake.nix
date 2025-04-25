{
  description = "My cross platform nix configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
	homeConfigurations = {
        MBP_M1 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ({ config, pkgs, ... }: {
              _module.args = {
                username = "michaelbaron";
                homeDirectory = "/Users/michaelbaron";
              };
            })
            ./home.nix
          ];
        };

        # michael-linux = home-manager.lib.homeManagerConfiguration {
        #   inherit pkgs;
        #   modules = [
        #     ({ config, pkgs, ... }: {
        #       _module.args = {
        #         username = "michael";
        #         homeDirectory = "/home/michael";
        #       };
        #     })
        #     ./home.nix
        #   ];
        # };
      };

	packages.default = pkgs.writeText "noop-home-config" ''
        This flake is only for home-manager modules.
        Nothing to build.
      '';
      }
    );
}
