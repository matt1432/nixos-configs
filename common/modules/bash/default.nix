# Home-manager module

{ config, lib, ... }: {
  imports = [
    ./programs.nix
  ];

  programs = {

    starship = let
      textColor   = "#e3e5e5";
      firstColor  = "#bd93f9";
      secondColor = "#715895";
      thirdColor  = "#382c4a";
      fourthColor = "#120e18";
    in {
      enable = true;
      enableBashIntegration = true;
      settings = {
        format = lib.concatStrings [
          "╭╴"
          "[](fg:${firstColor})"
          "[   ](bg:${firstColor} fg:#090c0c)"
          "[](bg:${secondColor} fg:${firstColor})"
          "$username$hostname"
          "$sudo"
          "[](fg:${secondColor} bg:${thirdColor})"
          "$directory"
          "[](fg:${thirdColor} bg:${fourthColor})"
          "$git_branch"
          "[](fg:${fourthColor})"
          "\n╰╴$shlvl$nix_shell$character"
        ];

        sudo = {
          disabled = false;
          style = "fg:${textColor} bg:${secondColor}";
          format = "[as root ]($style)";
        };

        username = {
          show_always = true;
          style_user = "fg:${textColor} bg:${secondColor}";
          style_root = "fg:red bg:${secondColor} blink";
          format = "[ $user]($style)";
        };

        hostname = {
          ssh_only = false;
          style = "fg:${textColor} bg:${secondColor}";
          format = "[@$hostname ]($style)";
        };

        directory = {
          style = "fg:${firstColor} bg:${thirdColor}";
          format = "[ $path ]($style)";
          truncate_to_repo = false;
          truncation_length = 0;

          substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };

        git_branch = {
          style = "fg:${secondColor} bg:${fourthColor}";
          symbol = "";
          format = "[ $symbol $branch ]($style)";
        };

        shlvl = {
          disabled = false;
          repeat = true;
          symbol = "󰔳 ";
          format = "[$symbol]($style)";
          threshold = 1;
        };

        nix_shell = {
          symbol = "❄️ ";
          format = "[$symbol]($style)";
        };

        character = {
          success_symbol = "[\\$](bold green)";
          error_symbol = "[\\$](bold red)";
        };
      };
    };

    bash = {
      enable = true;
      enableCompletion = true;

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

        nivm  = "nvim";
        nivim = "nvim";

        tmux  = "tmux -2";
        ls    = "ls -lah --color=auto";
        cp    = "cp -r";

        chore = "(cd ~/.nix; git add flake.lock; git commit -m 'chore: update flake.lock'; git push)";

        tup   = "tailscale up --login-server https://headscale.nelim.org";

        pc    = "mosh matt@binto -- tmux -2u new -At laptop";
        oksys = "mosh matt@oksys -- tmux -2u new -At laptop";
        pve   = "mosh matt@pve -- tmux -2u new -At laptop";

        mc    = "mosh mc@mc -- tmux -2u new -At laptop";
        pod   = "mosh matt@pve -- ssh -t -p 6768 matt@10.0.0.122 'tmux -2u new -At laptop'";
        jelly = "mosh matt@pve -- ssh -t matt@10.0.0.123 'tmux -2u new -At laptop'";
        qbit  = "mosh matt@pve -- ssh -t matt@10.0.0.128 'tmux -2u new -At laptop'";
      };
      sessionVariables = {
        # FIXME: why is this not set by home-manager?
        "RIPGREP_CONFIG_PATH" = "${config.xdg.configHome}/ripgrep/ripgreprc";
      };

      profileExtra = ''
        export POKE=true
        [[ -f ~/.bashrc ]] && . ~/.bashrc
      '';
      bashrcExtra = ''
        ${lib.strings.fileContents ./config/dracula/less.sh}
        ${lib.strings.fileContents ./config/dracula/fzf.sh}

        ${lib.strings.fileContents ./config/colorgrid.sh}
        ${lib.strings.fileContents ./config/bashrc}
      '';
      #initExtra = ''
      #'';
      #logoutExtra = ''
      #'';
    };
  };
}
