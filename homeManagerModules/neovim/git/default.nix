self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) vimplugin-gitsigns-src;

  inherit (builtins) fromJSON readFile;
  inherit (lib) mkIf substring;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs.neovim.plugins = [
      pkgs.vimPlugins.fugitive

      {
        plugin = let
          tag = (fromJSON (readFile "${vimplugin-gitsigns-src}/.release-please-manifest.json")).".";
          rev = "4666d040b60d1dc0e474ccd9a3fd3c4d67b4767c";
        in
          pkgs.vimPlugins.gitsigns-nvim.overrideAttrs (o: {
            version = "${tag}+${substring 0 7 rev}";
            src = vimplugin-gitsigns-src;
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
