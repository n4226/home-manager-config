{ config, pkgs, nixvim-flake, system, homeDirectory, username, ... }:

{

  home.username = username;
  home.homeDirectory = homeDirectory;

  # ← this is _mandatory_
  home.stateVersion = "24.11";   # choose the HM release you want
  programs.zoxide.enable = true;
  programs.home-manager.enable = true;

  # want to put in mac_apps here 

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    meslo-lgs-nf

    thefuck
    nixvim-flake.packages.${system}.default 
    tree
    neofetch
    # for nixvim obsidan
    ripgrep
    nixfmt
  ] 
    # macos only packages
    ++ (if pkgs.stdenv.isDarwin then [ 
      iterm2
    ] else []);

  #write iterm2 config file
  home.file.".config/iterm2/com.googlecode.iterm2.plist".source = ./dotfiles/iterm2/com.googlecode.iterm2.plist;
  #home.file.".tmux.conf".source = ./dotfiles/tmux/tmux.conf;


  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 100000;
    plugins = with pkgs.tmuxPlugins; [
      # catppuccin
      tokyo-night-tmux
    ];
    extraConfig = ''
      #load my config
      source-file ${./dotfiles/tmux/tmux.conf}

    # Load the Tokyo Night theme
    run-shell ${pkgs.tmuxPlugins.tokyo-night-tmux}/tokyo-night.tmux
    '';
  };


  programs.zsh = {
    enable = true;
    enableAutosuggestions = true; # optional but nice
    initExtra = ''
    bindkey -v
    '';

    plugins = [
      {
	name = "powerlevel10k-config";
	src = ./p10k-config;
	file = "p10k.zsh";
      }
    ];
    #
    zplug = {
      enable = true;
      plugins = [
	#{ name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
	{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } 
      ];
    };
  };

}
