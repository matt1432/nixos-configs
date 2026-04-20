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
                pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
            })

            vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                pattern = "hyprlang",
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
