{
  config,
  lib,
  ...
}: let
  inherit (lib) concatStrings fileContents;
  inherit (config.vars) promptColors;
in {
  imports = [./programs.nix];

  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;

      settings = {
        format = concatStrings [
          "╭╴"
          "[](fg:${promptColors.firstColor})"
          "[   ](bg:${promptColors.firstColor} fg:#090c0c)"
          "[](bg:${promptColors.secondColor} fg:${promptColors.firstColor})"
          "$username$hostname"
          "[](fg:${promptColors.secondColor} bg:${promptColors.thirdColor})"
          "$directory"
          "[](fg:${promptColors.thirdColor} bg:${promptColors.fourthColor})"
          "$git_branch"
          "[](fg:${promptColors.fourthColor})"
          "\n╰╴$shlvl$nix_shell$character"
        ];

        username = {
          show_always = true;
          style_user = "fg:${promptColors.textColor} bg:${promptColors.secondColor}";
          style_root = "fg:red bg:${promptColors.secondColor} blink";
          format = "[ $user]($style)";
        };

        hostname = {
          ssh_only = false;
          style = "fg:${promptColors.textColor} bg:${promptColors.secondColor}";
          format = "[@$hostname ]($style)";
        };

        directory = {
          style = "fg:${promptColors.firstColor} bg:${promptColors.thirdColor}";
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
          style = "fg:${promptColors.secondColor} bg:${promptColors.fourthColor}";
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

          ${fileContents ./config/dracula/less.sh}
          ${fileContents ./config/dracula/fzf.sh}

          ${fileContents ./config/colorgrid.sh}
          ${fileContents ./config/bashrc}
        '';
      #initExtra = ''
      #'';
      #logoutExtra = ''
      #'';
    };
  };
}
