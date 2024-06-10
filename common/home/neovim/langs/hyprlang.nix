{
  config,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        extraLuaConfig =
          # lua
          ''
            vim.filetype.add({
                pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang' },
            });

            vim.api.nvim_create_autocmd('FileType', {
               pattern = 'hyprlang',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
          '';
      };
    };
  }
