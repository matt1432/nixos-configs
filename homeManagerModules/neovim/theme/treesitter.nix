{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

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
            require('nvim-treesitter').setup({
                highlight = { enable = true },
                indent = { enable = true },
            });
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    local filetype = vim.filetype.match({
                        buf = vim.api.nvim_get_current_buf(),
                    });

                    for _, language in ipairs(require('nvim-treesitter').get_available()) do
                        if filetype == language then
                            vim.treesitter.start();
                            return;
                        end;
                    end;
                end,
            });
          '';
      }
    ];
  };

  # For accurate stack trace
  _file = ./treesitter.nix;
}
