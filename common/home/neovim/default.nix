{
  pkgs,
  lib,
  ...
}: let
  # installs a vim plugin from git with a given tag / branch
  plugin = src:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName src.repo}";
      version = src.rev;
      inherit src;
    };

  buildGrammar = name: grammar:
    pkgs.callPackage ./grammar.nix {} {
      language = grammar.language or name;
      version = grammar.src.rev;
      src = grammar.src;
      location = grammar.location or null;
      generate = grammar.generate or false;
    };

  fileContents = lib.strings.fileContents;
in {
  # TODO: make a gradle module and have java in device-vars.nix
  xdg.dataFile = {
    ".gradle/gradle.properties".source = pkgs.writeText "gradle.properties" ''
      org.gradle.java.home = ${pkgs.temurin-bin-17}
    '';
  };
  home.packages = with pkgs; [
    gradle
    gradle-completion # FIXME: not working
    alejandra
  ];

  programs = {
    java = {
      enable = true;
      package = pkgs.temurin-bin-17;
    };

    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = with pkgs; [
        nodejs_latest
        nodePackages.npm
        nodePackages.neovim
        gradle
        gcc

        bat

        nil
      ];
      extraPython3Packages = ps: [
        ps.pylint
      ];

      coc = {
        enable = true;
        settings = {
          # General
          colors.enable = true;
          coc.preferences.formatOnType = true;
          diagnostic.checkCurrentLine = true;
          inlayHint.enable = false;

          # ESLint
          eslint = {
            format.enable = true;
            autoFixOnSave = true;
          };

          # Stylelint
          stylelintplus = {
            enable = true;
            cssInJs = true;
            autoFixOnSave = true;
            autoFixOnFormat = true;
          };
          css.validate = false;
          less.validate = false;
          scss.validate = false;
          wxss.validate = false;

          # Lua
          Lua = {
            misc.parameters = [
              "--metapath"
              "~/.cache/sumneko_lua/meta"
              "--logpath"
              "~/.cache/sumneko_lua/log"
            ];
            workspace.library = [
              "$\{3rd\}/luv/library"
            ];
          };
          sumneko-lua = {
            serverDir = "${pkgs.lua-language-server}/share/lua-language-server";
            enableNvimLuaDev = true;
          };

          languageserver = {
            # Nix
            nix = {
              command = "nil";
              filetypes = ["nix"];
              rootPatterns = ["flake.nix"];
              settings = {
                nil = {
                  formatting = {command = ["alejandra"];};
                };
              };
            };
          };

          # Java
          java.jdt.ls = {
            java.home = "${pkgs.temurin-bin-17}";
            statusIcons = {
              "busy" = "Busy";
              "ready" = "OK";
              "warning" = "Warning";
              "error" = "Error";
            };
          };

          # Bash
          bashIde.shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
        };
      };

      extraConfig = fileContents ./base.vim;
      extraLuaConfig = fileContents ./base.lua;

      plugins = let
        # custom packages
        hypr-src = pkgs.fetchFromGitHub {
          owner = "luckasRanarison";
          repo = "tree-sitter-hypr";
          rev = "90b3ddf8a85b5ea3d9dc4920fddb16182a192e14";
          hash = "sha256-ErFs2eCC0eZEyDldrTUj4JJ0Eu+exDHNQx4g8WXh/UQ=";
        };

        tree-sitter-hypr = plugin hypr-src;

        hypr-grammar = buildGrammar "hypr" {
          src = hypr-src;
          generate = true;
        };

        indent-blankline = plugin (pkgs.fetchFromGitHub {
          owner = "lukas-reineke";
          repo = "indent-blankline.nvim";
          rev = "046e2cf04e08ece927bacbfb87c5b35c0b636546";
          hash = "sha256-bhoep8aTYje5K/dZ/XmpwBPn4PBEMPrmw33QJdfFe6M=";
        });
      in
        with pkgs.vimPlugins; [
          # Coc configured
          coc-css
          coc-eslint
          coc-java
          coc-sh
          coc-stylelintplus
          {
            plugin = coc-snippets;
            type = "viml";
            config = fileContents ./plugins/snippets.vim;
          }

          ## Lua
          coc-sumneko-lua
          neodev-nvim

          ## Fzf
          coc-fzf
          fzfWrapper
          fzf-vim

          coc-highlight
          coc-json
          coc-pyright
          coc-vimlsp
          coc-yaml
          coc-toml
          coc-markdownlint
          coc-tsserver
          fugitive

          {
            plugin = dracula-nvim;
            type = "viml";
            config = fileContents ./plugins/dracula.vim;
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config = fileContents ./plugins/lualine.lua;
          }
          {
            plugin = todo-comments-nvim;
            type = "lua";
            config = "require('todo-comments').setup()";
          }
          {
            plugin = gitsigns-nvim;
            type = "lua";
            config = fileContents ./plugins/gitsigns.lua;
          }
          {
            plugin = nvim-autopairs;
            type = "lua";
            config = fileContents ./plugins/autopairs.lua;
          }
          nvim-treesitter-context
          nvim-treesitter-textobjects
          {
            plugin = tree-sitter-hypr;
            type = "lua";
            config = ''
              vim.treesitter.language.require_language("hypr", "${hypr-grammar}/parser")
            '';
          }
          {
            plugin = nvim-treesitter.withAllGrammars;
            type = "viml";
            config = fileContents ./plugins/treesitter.vim;
          }
          {
            plugin = indent-blankline;
            type = "lua";
            config = fileContents ./plugins/indent.lua;
          }
          {
            plugin = mini-nvim;
            type = "lua";
            config = fileContents ./plugins/mini.lua;
          }
          {
            plugin = neo-tree-nvim;
            type = "viml";
            config = ''
              ${fileContents ./plugins/neotree.vim}

              lua << EOF
                ${fileContents ./plugins/neotree.lua}
              EOF
            '';
          }
        ];
    };
  };
}
