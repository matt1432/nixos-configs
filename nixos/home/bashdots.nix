{ lib, ... }:
 
{
  programs.bash = {   # TODO: deal with root dotfiles
    enable = true;
    enableCompletion = true;
    #enableVteIntegration = false; what is this?

    historyFile     = "\$HOME/.cache/.bash_history";
    historyFileSize = 100000; # default
    historySize     = 10000; # default
    historyControl  = [
      "erasedups"
      "ignorespace"
    ];
    historyIgnore = [
      "ls"
      "exit"
      "logout"
    ];

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
      "autocd"
      "cdspell"
      "dirspell"
      "dotglob"
    ];

    shellAliases = {
      sudo  = "sudo ";
      frick = "sudo $(fc -ln -1)";

      vi    = "nvim";
      vim   = "nvim";
      nivm  = "nvim";
      nivim = "nvim";

      tmux  = "tmux -2";
      ls    = "ls -lah --color=auto";
      cp    = "cp -r";

      tup   = "tailscale up --login-server https://headscale.nelim.org";

      pc    = "mosh matt@10.0.0.248 -- tmux -2u new -At laptop";
      oksys = "mosh matt@10.0.0.213 -- tmux -2u new -At laptop";
      pve   = "mosh matt@10.0.0.121 -- tmux -2u new -At laptop";

      mc    = "mosh mc@10.0.0.124 -- tmux -2u new -At laptop";
      pod   = "mosh matt@10.0.0.121 -- ssh -t -p 6768 matt@10.0.0.122 'tmux -2u new -At laptop'";
      jelly = "mosh matt@10.0.0.121 -- ssh -t matt@10.0.0.123 'tmux -2u new -At laptop'";
      qbit  = "mosh matt@10.0.0.121 -- ssh -t matt@10.0.0.128 'tmux -2u new -At laptop'";
    };
    sessionVariables = { # see configuration.nix
    };

    profileExtra = ''
      export POKE=true
      [[ -f ~/.bashrc ]] && . ~/.bashrc
    '';
    bashrcExtra = ''
      ${lib.strings.fileContents ../../config/bash/dracula/less.sh}
      ${lib.strings.fileContents ../../config/bash/dracula/fzf.sh}

      ${lib.strings.fileContents ../../config/bash/colorgrid.sh}
      ${lib.strings.fileContents ../../config/bash/bashrc}
    '';
    #initExtra = ''
    #'';
    #logoutExtra = ''
    #'';
  };
}
