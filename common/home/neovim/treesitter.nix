{pkgs, ...}: let
  inherit (pkgs) vimPlugins;
in {
  programs = {
    neovim = {
      plugins = [
        {
          plugin = vimPlugins.nvim-treesitter-context;
          type = "lua";
          config =
            /*
            lua
            */
            ''
              require('treesitter-context').setup({
                  enable = true,
                  max_lines = 3,
                  min_window_height = 20,
              });

              vim.cmd(
                  'hi TreesitterContextBottom gui=underline guisp=Grey'
              );
            '';
        }

        vimPlugins.nvim-treesitter-textobjects

        {
          type = "lua";
          config =
            /*
            lua
            */
            ''
              require('nvim-treesitter.configs').setup({
                  highlight = { enable = true },
                  indent = { enable = true },
              });

              vim.filetype.add({
                  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
              });
            '';
          plugin = vimPlugins.nvim-treesitter.withPlugins (p: [
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
      ];
    };
  };
}
