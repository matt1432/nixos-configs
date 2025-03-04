self: {
  config,
  lib,
  ...
}: let
  inherit (lib) fileContents mkIf mkOption types;

  cfg = config.programs.bash;
in {
  imports = [
    ./starship
    ./trash
    (import ./git self)
    (import ./misc self)
    (import ./nix-tools self)
  ];

  options.programs.bash = {
    promptMainColor = mkOption {
      type = types.enum (import ./prompt-schemes.nix {});
      default = "purple";
    };

    promptColors = mkOption {
      description = ''
        Colors used in starship prompt
      '';

      default = import ./prompt-schemes.nix {color = cfg.promptMainColor;};

      readOnly = true;
      type = types.submodule {
        options = let
          inherit (types) str;
        in {
          textColor = mkOption {type = str;};
          firstColor = mkOption {type = str;};
          secondColor = mkOption {type = str;};
          thirdColor = mkOption {type = str;};
          fourthColor = mkOption {type = str;};
        };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
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

        ls = "ls -lah --color=auto";
        tree = "tree -a -I node_modules -I .git --gitignore";
        cp = "cp -r";
      };

      #profileExtra = ''
      #'';
      bashrcExtra =
        # bash
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

  # For accurate stack trace
  _file = ./default.nix;
}
