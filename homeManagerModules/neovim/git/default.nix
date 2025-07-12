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
          rev = "4666d040b60d1dc0e474ccd9a3fd3c4d67b4767c";
        in
          pkgs.vimPlugins.gitsigns-nvim.overrideAttrs (o: {
            version = "1.0.2+${substring 0 7 rev}";
            src = pkgs.fetchFromGitHub {
              owner = "lewis6991";
              repo = "gitsigns.nvim";
              inherit rev;
              hash = "sha256-81sJe2qkEmq9QeiZvGKKaAfv8Fx1EDxn+A1AeNFl2aE=";
            };
          });
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
