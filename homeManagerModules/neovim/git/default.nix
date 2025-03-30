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
      pkgs.vimPlugins.fugitive

      {
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        type = "lua";
        config =
          # lua
          ''
            local gitsigns = require("gitsigns");

            vim.keymap.set("v", "gs", function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') });
            end);

            gitsigns.setup();
          '';
      }
    ];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
