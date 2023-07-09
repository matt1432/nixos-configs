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
    sessionVariables = { # see configuration.nix
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

      ### DRACULA

      export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

      #man-page colors
      export LESS_TERMCAP_mb=$'\e[1;31m'      # begin bold
      export LESS_TERMCAP_md=$'\e[1;34m'      # begin blink
      export LESS_TERMCAP_so=$'\e[01;45;37m'  # begin reverse video
      export LESS_TERMCAP_us=$'\e[01;36m'     # begin underline
      export LESS_TERMCAP_me=$'\e[0m'         # reset bold/blink
      export LESS_TERMCAP_se=$'\e[0m'         # reset reverse video
      export LESS_TERMCAP_ue=$'\e[0m'         # reset underline

      if [ "$TERM" = "linux" ]; then
        printf %b '\e[40m' '\e[8]' # set default background to color 0 'dracula-bg'
        printf %b '\e[37m' '\e[8]' # set default foreground to color 7 'dracula-fg'
        printf %b '\e]P0282a36'    # redefine 'black'          as 'dracula-bg'
        printf %b '\e]P86272a4'    # redefine 'bright-black'   as 'dracula-comment'
        printf %b '\e]P1ff5555'    # redefine 'red'            as 'dracula-red'
        printf %b '\e]P9ff7777'    # redefine 'bright-red'     as '#ff7777'
        printf %b '\e]P250fa7b'    # redefine 'green'          as 'dracula-green'
        printf %b '\e]PA70fa9b'    # redefine 'bright-green'   as '#70fa9b'
        printf %b '\e]P3f1fa8c'    # redefine 'brown'          as 'dracula-yellow'
        printf %b '\e]PBffb86c'    # redefine 'bright-brown'   as 'dracula-orange'
        printf %b '\e]P4bd93f9'    # redefine 'blue'           as 'dracula-purple'
        printf %b '\e]PCcfa9ff'    # redefine 'bright-blue'    as '#cfa9ff'
        printf %b '\e]P5ff79c6'    # redefine 'magenta'        as 'dracula-pink'
        printf %b '\e]PDff88e8'    # redefine 'bright-magenta' as '#ff88e8'
        printf %b '\e]P68be9fd'    # redefine 'cyan'           as 'dracula-cyan'
        printf %b '\e]PE97e2ff'    # redefine 'bright-cyan'    as '#97e2ff'
        printf %b '\e]P7f8f8f2'    # redefine 'white'          as 'dracula-fg'
        printf %b '\e]PFffffff'    # redefine 'bright-white'   as '#ffffff'
      fi
    '';
    #initExtra = ''
    #'';
    #logoutExtra = ''
    #'';
  };
}
