{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit (pkgs) rust-analyzer;
        };

        initLua =
          # lua
          ''
            vim.lsp.enable("rust_analyzer")
            vim.lsp.config("rust_analyzer", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                pattern = { "rust" },

                callback = function(args)
                    vim.bo[args.buf].ts = 4;
                    vim.bo[args.buf].sw = 4;
                    vim.bo[args.buf].sts = 0;
                    vim.bo[args.buf].expandtab = true;
                end,
            })
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
