{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues getExe mkIf;

  cfg = config.programs.neovim;
in {
  programs = mkIf cfg.enable {
    # I love doing typos
    bash.shellAliases = {
      nivm = "nvim";
      nivim = "nvim";
    };

    neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      extraPackages = mkIf cfg.enableIde (attrValues {
        inherit
          (pkgs.nodePackages)
          bash-language-server
          ;

        inherit
          (pkgs)
          shellcheck
          ;
      });

      extraLuaConfig =
        mkIf cfg.enableIde
        # lua
        ''
          vim.api.nvim_create_autocmd('FileType', {
              pattern = 'sh',
              command = 'setlocal ts=4 sw=4 sts=0 expandtab',
          });

          local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

          require('lspconfig').bashls.setup({
              capabilities = default_capabilities,

              settings = {
                  bashIde = {
                      shellcheckPath = '${getExe pkgs.shellcheck}',
                  },
              },
          });
        '';
    };
  };
}
