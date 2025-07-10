{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf substring;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs.neovim.plugins = [
      pkgs.vimPlugins.fugitive

      {
        # FIXME: wait for it to reach nixpkgs
        plugin = let
          rev = "7bbc674278f22376850576dfdddf43bbc17e62b5";
        in
          pkgs.vimPlugins.gitsigns-nvim.overrideAttrs {
            version = "1.0.2+${substring 0 7 rev}";
            src = pkgs.fetchFromGitHub {
              owner = "lewis6991";
              repo = "gitsigns.nvim";
              inherit rev;
              hash = "sha256-bIpIT3yS+Mk6p8FRxEUQ3YcsaoOjkSVZGOdcvCvmP00=";
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
