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
        # FIXME: wait for it to reach nixpkgs
        plugin = pkgs.vimPlugins.gitsigns-nvim.overrideAttrs rec {
          version = "1.0.2";
          src = pkgs.fetchFromGitHub {
            owner = "lewis6991";
            repo = "gitsigns.nvim";
            tag = "v${version}";
            hash = "sha256-qWusbKY+3d1dkW5oLYDyfSLdt1qFlJdDeXgFWqQ4hUI=";
          };
        };
        type = "lua";
        config =
          # lua
          ''
            --
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
