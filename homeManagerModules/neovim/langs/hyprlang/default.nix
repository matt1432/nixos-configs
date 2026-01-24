{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        initLua =
          # lua
          ''
            vim.filetype.add({
                pattern = { [ '.*/hypr/.*%.conf' ] = 'hyprlang' },
            });

            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
               pattern = 'hyprlang',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
