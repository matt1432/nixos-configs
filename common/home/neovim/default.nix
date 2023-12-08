{
  config,
  pkgs,
  lib,
  coc-stylelintplus-flake,
  tree-sitter-hypr-flake,
  ...
}:
with lib; let
  nvimIde = config.vars.neovimIde;

  javaSdk = pkgs.temurin-bin-17;
  nvim-treesitter-hypr = tree-sitter-hypr-flake.packages.${pkgs.system}.default;
  coc-stylelintplus = coc-stylelintplus-flake.packages.${pkgs.system}.default;
in {
  home.packages = optionalAttrs nvimIde (with pkgs; [
    gradle
    gradle-completion # FIXME: not working
    alejandra
  ]);

  xdg.dataFile = optionalAttrs nvimIde {
    ".gradle/gradle.properties".text = ''
      org.gradle.java.home = ${javaSdk}
    '';
  };

  programs = {
    java = optionalAttrs nvimIde {
      enable = true;
      package = javaSdk;
    };

    # I love doing typos
    bash.shellAliases = {
      nivm = "nvim";
      nivim = "nvim";
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

      extraPackages = with pkgs; ([
          bat
          gcc
        ]
        ++ optionals nvimIde [
          nodejs_latest
          nodePackages.npm
          nodePackages.neovim
          gradle
          nil
        ]);

      extraPython3Packages = ps:
        optionals nvimIde [
          ps.pylint
        ];

      coc = optionalAttrs nvimIde {
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
            java.home = "${javaSdk}";
            statusIcons = {
              "busy" = "Busy";
              "ready" = "OK";
              "warning" = "Warning";
              "error" = "Error";
            };
          };

          # Bash
          bashIde.shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";

          markdownlint.config = {
            no-trailing-spaces = true;
            no-multiple-blanks = false;
            no-duplicate-heading = false;
          };
        };
      };

      extraConfig = fileContents ./base.vim;
      extraLuaConfig = fileContents ./base.lua;

      plugins = with pkgs.vimPlugins; ([
          fzfWrapper
          fzf-vim
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
        ]
        ++ optionals nvimIde [
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

          coc-highlight
          coc-json
          coc-pyright
          coc-vimlsp
          coc-yaml
          coc-toml
          coc-markdownlint
          coc-tsserver

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
        ]);
    };
  };
}
