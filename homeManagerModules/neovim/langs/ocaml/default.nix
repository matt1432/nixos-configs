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
        extraLuaConfig =
          # lua
          ''
            --
            loadDevShell({
                name = 'ocaml',
                pattern = {
                    'ocaml',
                    'menhir',
                    'ocamlinterface',
                    'ocamllex',
                    'reason',
                    'dune'
                },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    ocamllsp = function(start)
                        start();
                    end,
                },
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
