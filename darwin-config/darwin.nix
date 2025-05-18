{ pkgs, self-flake, username, system, my-home-module, home-manager, ... }:
let macos_apps = import ./macos-apps-fix.nix { inherit (home-manager) lib; };
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];

  # Necessary f-or using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # let nix-darwin manage zsh and create /etc/zsh{env,rc,profile}
  programs.zsh.enable = true;

  users.users.${username} = {
    home = /Users/${username};
    # shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true; # reuse the system’s pkgs set
    useUserPackages = true;

    users."${username}" = macos_apps // {
      imports = [
        ({ config, pkgs, ... }: {
          _module.args = {
            username = "${username}";
            homeDirectory = /Users/${username};
            system = "aarch64-darwin";
          };
        })
        my-home-module
      ];
    };
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self-flake.rev or self-flake.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
