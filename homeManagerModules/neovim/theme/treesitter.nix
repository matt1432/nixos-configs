self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (self.inputs) vimplugin-jinja-vim-src;
  inherit (self.lib.${pkgs.system}) buildPlugin;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs.neovim.plugins = [
      {
        plugin = pkgs.vimPlugins.nvim-treesitter-context;
        type = "lua";
        config =
          # lua
          ''
            require('treesitter-context').setup({
                enable = true,
                max_lines = 3,
                min_window_height = 20,
            });

            vim.cmd.hi('TreesitterContextBottom', 'gui=underline guisp=Grey');
          '';
      }

      pkgs.vimPlugins.nvim-treesitter-textobjects

      {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config =
          # lua
          ''
            require('nvim-treesitter.configs').setup({
                highlight = { enable = true },
                indent = { enable = true },
            });
          '';
      }

      {
        plugin = buildPlugin "jinja-vim" vimplugin-jinja-vim-src;
        type = "lua";
        config =
          # lua
          ''
            --
            vim.api.nvim_create_autocmd('BufEnter', {
                pattern = '*.j2',
                command = "TSBufDisable highlight | LspStop",
            });
          '';
      }
    ];
  };

  # For accurate stack trace
  _file = ./treesitter.nix;
}
