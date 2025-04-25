{ config, pkgs, ... }:

{

      # ← this is _mandatory_
      home.stateVersion = "24.11";   # choose the HM release you want
      programs.zoxide.enable = true;

      # want to put in mac_apps here 


      home.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	meslo-lgs-nf

	iterm2
	# thefuck
      ];

      programs.tmux = {
	enable = true;
	clock24 = true;
	historyLimit = 100000;
	plugins = with pkgs.tmuxPlugins; [
	  catppuccin
	];
	extraConfig = ''
		    # set-option -g status-position top
		    # bind -n Super_L send-keys "A-j"
		     \'\';
		     #   # bind -n D-j send-keys "A-j"
		     #   # bind -n D-k send-keys "A-k"
		     # \'\';
		     # 1) allow tmux to see and pass through Meta-modifiers
		     set -g xterm-keys on

		# 2) bind M-j and M-k at the tmux level to literally resend M-j/k
		#    (unbind first in case tmux has a built-in binding)
		unbind -n M-j
		unbind -n M-k
		bind -n M-j send-keys M-j
		bind -n M-k send-keys M-k
	'';
      };


      programs.zsh = {
	enable = true;

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
