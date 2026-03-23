# https://github.com/SRachamim/etc-nixos/blob/1dc73f9ffef22accb17ac1088bf095b3bbc3da47/home.nix
self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.${pkgs.stdenv.hostPlatform.system}) mkVersion;
  inherit (self.inputs) vimplugin-agentic-src;

  inherit (lib) mkIf;

  cfg = config.programs.neovim;

  model = "composer-2-fast";
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableLLMs) {
    home.sessionPath = ["$HOME/.local/bin"];

    home.activation = {
      installCursorCli =
        config.lib.dag.entryAfter ["writeBoundary"]
        # bash
        ''
          if ! [ -x "$HOME/.local/bin/cursor-agent" ]; then
              echo "Installing Cursor CLI..."
              ${pkgs.curl}/bin/curl https://cursor.com/install -fsS | PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:${pkgs.coreutils}/bin:$PATH" ${pkgs.bash}/bin/bash
          fi
        '';

      installCursorAgentAcp =
        config.lib.dag.entryAfter ["writeBoundary" "installCursorCli"]
        # bash
        ''
          # Install cursor-agent-acp if not present
          if ! [ -x "$HOME/.npm-global/bin/cursor-agent-acp" ]; then
              echo "Installing cursor-agent-acp..."
              export NPM_CONFIG_PREFIX="$HOME/.npm-global"
              export NPM_CONFIG_CACHE="$HOME/.npm-global/.cache"
              mkdir -p "$HOME/.npm-global" "$HOME/.npm-global/.cache"
              ${pkgs.nodejs}/bin/npm install -g @blowmage/cursor-agent-acp
          fi
        '';
    };

    # Force the use of a model
    home.file.".npm-global/bin/cursor-agent".source = pkgs.writeShellScript "cursor-agent" ''
      args=()
      skip=0

      for arg in "$@"; do
          if [ "$skip" -eq 1 ]; then
              skip=0
              continue
          fi
          case "$arg" in
              --model)
                  skip=1
                  continue
              ;;
              --model=*)
                  continue
              ;;
              --force)
                  continue
              ;;
              -f)
                  continue
              ;;
          esac
          args+=("$arg")
      done

      exec "$HOME/.local/bin/cursor-agent" --trust --model ${model} "''${args[@]}"
    '';

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
              require('render-markdown').setup({
                  file_types = { 'AgenticChat', 'AgenticCode', 'AgenticFiles' },
                  anti_conceal = { enabled = false },
                  render_modes = true,
              });

              vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                  pattern = { 'AgenticChat', 'AgenticCode', 'AgenticFiles' },
                  callback = function(args)
                      local buf = args.buf;
                      vim.treesitter.start(buf, 'markdown');
                  end,
              });
            '';
          }

          {
            plugin = pkgs.vimUtils.buildVimPlugin {
              pname = "agentic-nvim";
              src = vimplugin-agentic-src;
              version = mkVersion vimplugin-agentic-src;
              doCheck = false;
            };
            type = "lua";
            config = ''
              local agentic = require('agentic');

              agentic.setup({
                  provider = 'cursor-agent-acp',
                  debug = false,
                  acp_providers = {
                      ['cursor-agent-acp'] = {
                          name = 'Cursor Agent ACP',
                          command = vim.fn.expand('~/.npm-global/bin/cursor-agent-acp'),
                          args = {},
                          env = {
                              PATH = vim.fn.expand('~/.npm-global/bin') .. ':' .. vim.fn.expand('~/.local/bin') .. ':' .. vim.env.PATH,
                          },
                      },
                  },
              });

              vim.keymap.set({ 'n', 'v' }, '<leader>at', function()
                  agentic.toggle();
              end);
              vim.keymap.set({ 'n', 'v' }, '<leader>aa', function()
                  agentic.add_selection_or_file_to_context();
              end);
              vim.keymap.set({ 'n', 'v' }, '<leader>an', function()
                  agentic.new_session();
              end);
              vim.keymap.set({ 'n', 'v' }, '<leader>ac', function()
                  agentic.close();
              end);
              vim.keymap.set({ 'n', 'v' }, '<leader>ao', function()
                  agentic.open();
              end);
              vim.keymap.set({ 'n' }, '<leader>af', function()
                  agentic.add_file();
              end);
              vim.keymap.set({ 'v' }, '<leader>as', function()
                  agentic.add_selection();
              end);
              vim.keymap.set({ 'n', 'v' }, '<leader>aS', function()
                  agentic.stop_generation();
              end);
            '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
