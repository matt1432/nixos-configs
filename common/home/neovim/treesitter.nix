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

              vim.cmd.hi('TreesitterContextBottom', 'gui=underline guisp=Grey');
            '';
        }

        vimPlugins.nvim-treesitter-textobjects

        {
          plugin = vimPlugins.nvim-treesitter.withAllGrammars;
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
            '';
        }
      ];
    };
  };
}
