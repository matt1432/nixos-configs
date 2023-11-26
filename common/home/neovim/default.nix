{
  pkgs,
  lib,
  tree-sitter-hypr,
  ...
}: let
  fileContents = lib.strings.fileContents;
  nvim-treesitter-hypr = tree-sitter-hypr.packages.${pkgs.system}.default;
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

      plugins = with pkgs.vimPlugins; [
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
        nvim-treesitter-hypr
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "viml";
          config = fileContents ./plugins/treesitter.vim;
        }
        {
          plugin = indent-blankline-nvim;
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
