{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues getExe mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableBash) {
    programs = {
      # I love doing typos
      bash.shellAliases = {
        nivm = "nvim";
        nivim = "nvim";
      };

      neovim = {
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        # We keep the packages here because shell scripts are too common
        extraPackages = attrValues {
          inherit
            (pkgs.nodePackages)
            bash-language-server
            ;

          inherit
            (pkgs)
            shellcheck
            ;
        };

        initLua =
          # lua
          ''
            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = 'sh',
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            vim.lsp.enable('bashls');
            vim.lsp.config('bashls', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                settings = {
                    bashIde = {
                        shellcheckPath = '${getExe pkgs.shellcheck}',
                    },
                },
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
