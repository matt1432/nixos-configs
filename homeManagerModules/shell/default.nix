self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents mkIf mkOption optionalString types;

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
    enableNvm = mkOption {
      type = types.bool;
      default = false;
    };

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

          ${optionalString cfg.enableNvm
            # bash
            ''
              export NVM_DIR="$HOME/.nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
              [[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion
            ''}
        '';
      #initExtra = ''
      #'';
      #logoutExtra = ''
      #'';
    };

    home.file = mkIf cfg.enableNvm {
      ".nvm" = {
        recursive = true;
        source = pkgs.fetchFromGitHub {
          owner = "nvm-sh";
          repo = "nvm";
          tag = "v0.40.3";
          sha256 = "sha256-s36EQojnNKm4x410nllC3nbnzzwcLZCKSP3DkJPpjjo=";
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
