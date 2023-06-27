{ pkgs, ... }:

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
    ]
    ;
    shellAliases = {
      sudo  = "sudo ";
      frick = "sudo $(fc -ln -1)";

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
    sessionVariables = { # see hyprland.nix
      TERM = "xterm-color";
    };

    profileExtra = ''
      export POKE=true
      [[ -f ~/.bashrc ]] && . ~/.bashrc
    '';
    bashrcExtra = ''
      PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
      [[ -d ~/.local/bin ]] && PATH+=":$HOME/.local/bin"

      USER_COLOR="01;32m"
      HOST_COLOR="183m"
      PS1="\[\033[$USER_COLOR\]\u\[\033[01;38;5;$HOST_COLOR\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ "

      # source: https://stackoverflow.com/a/44232192
      PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

      [ -x "$(command -v pokemon-colorscripts)" ] &&
      [ "$POKE" == "true" ] &&
      pokemon-colorscripts -r 1-5

      function colorgrid() {
        iter=16
        while [ $iter -lt 52 ]
        do
          second=$[$iter+36]
          third=$[$second+36]
          four=$[$third+36]
          five=$[$four+36]
          six=$[$five+36]
          seven=$[$six+36]
          if [ $seven -gt 250 ];then seven=$[$seven-251]; fi

          echo -en "\033[38;5;$(echo $iter)m█ "
          printf "%03d" $iter
          echo -en "   \033[38;5;$(echo $second)m█ "
          printf "%03d" $second
          echo -en "   \033[38;5;$(echo $third)m█ "
          printf "%03d" $third
          echo -en "   \033[38;5;$(echo $four)m█ "
          printf "%03d" $four
          echo -en "   \033[38;5;$(echo $five)m█ "
          printf "%03d" $five
          echo -en "   \033[38;5;$(echo $six)m█ "
          printf "%03d" $six
          echo -en "   \033[38;5;$(echo $seven)m█ "
          printf "%03d" $seven

          iter=$[$iter+1]
          printf '\r\n'
        done
      }
    '';
    #initExtra = ''
    #'';
    #logoutExtra = ''
    #'';
  };
}
