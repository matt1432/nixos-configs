self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkIf;

  cfg = config.programs.neovim;

  opencodeExe =
    if cfg.ideConfig.llmProvider == "opencode"
    then getExe pkgs.opencode
    else "";
in {
  config = mkIf (cfg.enable && cfg.ideConfig.llmProvider != "none") {
    programs = {
      neovim = {
        extraPackages = [
          pkgs.python3Packages.pylatexenc
        ];

        plugins = [
          {
            plugin = pkgs.vimPlugins.render-markdown-nvim;
            type = "lua";
            config = ''
              require("render-markdown").setup({
                  file_types = { "Avante" },
                  anti_conceal = { enabled = false },
                  render_modes = true,
              })

              vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                  pattern = { "Avante" },
                  callback = function(args)
                      local buf = args.buf
                      vim.treesitter.start(buf, "markdown")
                  end,
              })
            '';
          }

          pkgs.vimPlugins.nui-nvim
          pkgs.vimPlugins.dressing-nvim
          {
            plugin = pkgs.vimPlugins.avante-nvim;
            type = "lua";
            config = ''
              require("avante").setup({
                  provider = "${cfg.ideConfig.llmProvider}",
                  mode = "agentic",
                  ${
                if cfg.ideConfig.llmProvider == "opencode"
                then
                  # lua
                  ''
                    providers = {
                        llamacpp = {
                            __inherited_from = 'openai',
                            endpoint = 'http://100.64.0.4:9292/v1',
                            model = 'Qwen3.5-35B-A3B-GGUF',
                            timeout = 1000000, -- Timeout in milliseconds
                            disable_tools = false,
                            api_key_name = "TERM",
                        },
                    },
                  ''
                else ""
              }
                  acp_providers = {
                      opencode = {
                          command = "${opencodeExe}",
                          args = { "acp" },
                          env = {},
                      },
                  },
              })

              local api = require("avante.api")

              vim.keymap.set({ "n", "v" }, "<leader>at", function()
                  api.toggle()
              end)
              vim.keymap.set({ "n", "v" }, "<leader>aa", function()
                  api.ask()
              end)
              vim.keymap.set({ "n", "v" }, "<leader>an", function()
                  api.new_chat()
              end)
              vim.keymap.set({ "n", "v" }, "<leader>ac", function()
                  api.close()
              end)
              vim.keymap.set({ "n", "v" }, "<leader>ao", function()
                  api.focus()
              end)
              vim.keymap.set({ "n" }, "<leader>af", function()
                  api.add_file()
              end)
              vim.keymap.set({ "v" }, "<leader>as", function()
                  api.add_selection()
              end)
              vim.keymap.set({ "n", "v" }, "<leader>aS", function()
                  api.stop()
              end)
            '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
