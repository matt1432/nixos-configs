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
  inherit (builtins) toJSON;

  cfg = config.programs.neovim;
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableLLMs) {
    home.sessionPath = ["$HOME/.local/bin"];

    home.file."cursor-agent-acp-config" = {
      target = ".config/cursor-agent-acp/config.json";
      text = toJSON {
        cursorAgent = {
          model = "opus-4-thinking";
          args = ["--model" "opus-4-thinking"];
        };
      };
    };

    home.activation = {
      # TODO: add support for linux
      initCursorSettings =
        lib.dag.entryAfter ["writeBoundary"]
        # bash
        ''
          # Initialize Cursor settings if not present (don't overwrite user changes)
          CURSOR_SETTINGS="$HOME/Library/Application Support/Cursor/User/settings.json"
          mkdir -p "$(dirname "$CURSOR_SETTINGS")"

          # Remove symlink if it exists (from previous home-manager config)
          if [ -L "$CURSOR_SETTINGS" ]; then
              rm "$CURSOR_SETTINGS"
          fi

          # Copy initial settings only if file doesn't exist
          if [ ! -f "$CURSOR_SETTINGS" ]; then
              cat > "$CURSOR_SETTINGS" << 'EOF'
          {}
          EOF
          fi
        '';

      installCursorCli =
        lib.dag.entryAfter ["writeBoundary"]
        # bash
        ''
          if ! [ -x "$HOME/.local/bin/cursor-agent" ]; then
              echo "Installing Cursor CLI..."
              ${pkgs.curl}/bin/curl https://cursor.com/install -fsS | PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:${pkgs.coreutils}/bin:$PATH" ${pkgs.bash}/bin/bash
          fi
        '';

      installCursorAgentAcp =
        lib.dag.entryAfter ["writeBoundary" "installCursorCli"]
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

          # Create symlink so cursor-agent-acp can find cursor-agent
          if [ -x "$HOME/.local/bin/cursor-agent" ]; then
              ln -sf "$HOME/.local/bin/cursor-agent" "$HOME/.npm-global/bin/cursor-agent"
          fi
        '';
    };

    programs = {
      neovim = {
        plugins = [
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
                  provider = 'cursor-acp',
                  debug = false,
                  acp_providers = {
                      ['cursor-acp'] = {
                          name = 'Cursor Agent ACP',
                          command = vim.fn.expand('~/.npm-global/bin/cursor-agent-acp'),
                          args = { '-c', vim.fn.expand('~/.config/cursor-agent-acp/config.json') },
                          env = {
                              NODE_NO_WARNINGS = '1',
                              IS_AI_TERMINAL = '1',
                              PATH = vim.fn.expand('~/.npm-global/bin') .. ':' .. vim.fn.expand('~/.local/bin') .. ':' .. vim.env.PATH,
                              HOME = vim.fn.expand('~'),
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
