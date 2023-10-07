{ lib, ... }:
 
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = lib.concatStrings [
        "╭╴"
        "[](fg:#bd93f9)"
        "[   ](bg:#bd93f9 fg:#090c0c)"
        "[](bg:#715895 fg:#bd93f9)"
        "$username$hostname"
        "[](fg:#715895 bg:#382c4a)"
        "$directory"
        "[](fg:#382c4a bg:#120e18)"
        "$git_branch"
        "[](fg:#120e18)"
        "\n╰╴$shlvl$nix_shell$character"
      ];

      nix_shell = {
        #TODO
      };

      username = {
        show_always = true;
        style_user = "fg:#e3e5e5 bg:#715895";
        format = "[ $user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "fg:#e3e5e5 bg:#715895";
        format = "[@$hostname ]($style)";
      };

      shlvl = {
        disabled = false;
        repeat = true;
        symbol = "󰔳 ";
        format = "[$symbol]($style)";
        threshold = 1;
      };

      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };

      directory = {
        style = "fg:#bd93f9 bg:#382c4a";
        format = "[ $path ]($style)";
        truncate_to_repo = false;
        truncation_length = 0;
      };

      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
      };

      git_branch = {
        style = "fg:#715895 bg:#120e18";
        symbol = "";
        format = "[ $symbol $branch ]($style)";
      };
    };
  };

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
