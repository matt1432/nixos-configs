{lib, ...}: {
  imports = [./programs.nix];

  programs = {
    starship = let
      # TODO: have different colors depending on host
      textColor = "#e3e5e5";
      firstColor = "#bd93f9";
      secondColor = "#715895";
      thirdColor = "#382c4a";
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
          "[](fg:${secondColor} bg:${thirdColor})"
          "$directory"
          "[](fg:${thirdColor} bg:${fourthColor})"
          "$git_branch"
          "[](fg:${fourthColor})"
          "\n╰╴$shlvl$nix_shell$character"
        ];

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

      historyFile = "\$HOME/.cache/.bash_history";
      historyFileSize = 100000; # default
      historySize = 10000; # default
      historyControl = [
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
        # Add whitespace after, to allow
        # sudo to inherit all other aliases
        sudo = "sudo ";
        frick = "sudo $(fc -ln -1)";

        ls = "ls -lah --color=auto";
        tree = "tree -a -I node_modules";
        cp = "cp -r";

        chore =
          /*
          bash
          */
          ''
            (
            cd ~/.nix
            git add flake.lock
            git commit -m 'chore: update flake.lock'
            git push
            )
          '';
      };

      #profileExtra = ''
      #'';
      bashrcExtra =
        /*
        bash
        */
        ''
          # Check if shell is interactive
          [[ $- == *i* ]] || return 0

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
