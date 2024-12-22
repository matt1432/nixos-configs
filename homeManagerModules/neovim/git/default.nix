{pkgs, ...}: {
  programs.neovim.plugins = [
    pkgs.vimPlugins.fugitive

    {
      plugin = pkgs.vimPlugins.gitsigns-nvim;
      type = "lua";
      config =
        # lua
        ''
          local gitsigns = require("gitsigns");

          local function visual_stage()
              local first_line = vim.fn.line('v');
              local last_line = vim.fn.getpos('.')[2];
              gitsigns.stage_hunk({ first_line, last_line });
          end

          vim.keymap.set("v", "gs", function()
              visual_stage()
          end);

          gitsigns.setup();
        '';
    }
  ];
}
