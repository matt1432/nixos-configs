{
  config,
  pkgs,
  lib,
  nvim-theme-src,
  coc-stylelintplus,
  vimplugin-riscv-src,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (lib) fileContents hasAttr optionalAttrs optionals;

  javaSdk = pkgs.temurin-bin-17;
  coc-stylelintplus-flake = coc-stylelintplus.packages.${pkgs.system}.default;
in {
  home = optionalAttrs neovimIde {
    packages = with pkgs; [
      gradle
      maven
      alejandra
    ];
  };

  xdg.dataFile = optionalAttrs neovimIde {
    ".gradle/gradle.properties".text = ''
      org.gradle.java.home = ${javaSdk}
    '';
  };

  programs = {
    java = optionalAttrs neovimIde {
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
        ++ optionals neovimIde [
          clang-tools
          nodejs_latest
          nodePackages.npm
          nodePackages.neovim
          gradle
          nil
        ]);

      extraPython3Packages = ps:
        optionals neovimIde [
          ps.pylint
        ];

      coc = optionalAttrs neovimIde {
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
                  formatting.command = ["alejandra"];

                  nix = {
                    maxMemoryMB = 2560;
                    flake.autoArchive = hasAttr "sops" config;
                  };
                };
              };
            };
          };

          # Java
          java = {
            maven.downloadSources = true;
            eclipse.downloadSources = true;

            format.settings.url = "eclipse-formatter.xml";

            jdt.ls = {
              java.home = "${javaSdk}";
              statusIcons = {
                "busy" = "Busy";
                "ready" = "OK";
                "warning" = "Warning";
                "error" = "Error";
              };
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

      plugins = with pkgs.vimPlugins;
        ([
            fzfWrapper
            fzf-vim
            fugitive

            {
              plugin = dracula-nvim.overrideAttrs {
                src = nvim-theme-src;
              };
              type = "viml";
              config = fileContents ./plugins/dracula.vim;
            }
            {
              plugin = todo-comments-nvim;
              type = "lua";
              config =
                /*
                lua
                */
                ''require('todo-comments').setup()'';
            }
            {
              plugin = gitsigns-nvim;
              type = "lua";
              config = fileContents ./plugins/gitsigns.lua;
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
          ++ optionals neovimIde [
            markdown-preview-nvim

            # Coc configured
            coc-clangd
            coc-cmake
            coc-css
            coc-eslint
            coc-java
            coc-sh
            coc-stylelintplus-flake
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
              plugin = nvim-autopairs;
              type = "lua";
              config = fileContents ./plugins/autopairs.lua;
            }
            {
              plugin = lualine-nvim;
              type = "lua";
              config = fileContents ./plugins/lualine.lua;
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
            (pkgs.vimUtils.buildVimPlugin {
              name = "riscv-asm";
              src = vimplugin-riscv-src;
            })
          ])
        # Treesitter
        ++ (with pkgs.vimPlugins; [
          nvim-treesitter-context
          nvim-treesitter-textobjects
          {
            type = "viml";
            config = fileContents ./plugins/treesitter.vim;
            plugin = nvim-treesitter.withPlugins (p: [
              p.awk
              p.bash
              p.c
              p.c_sharp
              p.cairo
              p.cmake
              p.comment
              p.cpp
              p.css
              p.csv
              p.cuda
              p.diff
              p.dockerfile
              p.dot
              p.git_config
              p.git_rebase
              p.gitattributes
              p.gitcommit
              p.gitignore
              p.go
              p.gomod
              p.gosum
              p.groovy
              p.haskell
              p.haskell_persistent
              p.hyprlang
              p.html
              p.ini
              p.java
              p.javascript
              p.jq
              p.jsdoc
              p.json
              p.json5
              p.jsonc
              p.jsonnet
              p.kotlin
              p.latex
              p.lua
              p.luadoc
              p.make
              p.markdown
              p.meson
              p.ninja
              p.nix
              p.passwd
              p.perl
              p.php
              p.phpdoc
              p.properties
              p.python
              p.rasi
              p.regex
              p.requirements
              p.ruby
              p.rust
              p.scss
              p.sql
              p.ssh_config
              p.toml
              p.todotxt
              p.typescript
              p.udev
              p.vim
              p.vimdoc
              p.vue
              p.xml
              p.yaml
            ]);
          }
        ]);
    };
  };
}
