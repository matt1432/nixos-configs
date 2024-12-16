self: {
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.inputs) vimplugin-easytables-src;
  inherit (self.lib.${pkgs.system}) buildPlugin;

  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enableIde {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit
            (pkgs)
            pandoc
            texlab
            texliveFull
            rubber
            ;
        };

        extraLuaConfig =
          # lua
          ''
            local lsp = require('lspconfig');

            lsp.texlab.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                settings = {
                    texlab = {
                        formatterLineLength = 100,
                        latexFormatter = 'latexindent',
                        latexindent = {
                            modifyLineBreaks = false,
                            ["local"] = '.indentconfig.yaml';
                        },
                    },
                },
            });
          '';

        plugins = [
          {
            plugin = buildPlugin "easytables-nvim" vimplugin-easytables-src;
            type = "lua";
            config =
              # lua
              ''
                require('easytables').setup();
              '';
          }

          {
            plugin = pkgs.vimPlugins.knap;
            type = "lua";
            config =
              # lua
              ''
                --
                vim.api.nvim_create_autocmd('FileType', {
                    pattern = 'tex',
                    command = 'setlocal ts=4 sw=4 sts=0 expandtab',
                });

                vim.g.knap_settings = {
                    -- HTML
                    htmloutputext = 'html',
                    htmltohtml = 'none',
                    htmltohtmlviewerlaunch = "",
                    htmltohtmlviewerrefresh = 'none',

                    -- Markdown
                    mdoutputext = 'html',
                    markdownoutputext = 'html',

                    -- Markdown to PDF
                    mdtopdf = 'pandoc %docroot% -o /tmp/%outputfile%',
                    markdowntopdf = 'pandoc %docroot% -o /tmp/%outputfile%',
                    mdtopdfviewerlaunch = 'sioyek /tmp/%outputfile%',
                    markdowntopdfviewerlaunch = 'sioyek /tmp/%outputfile%',
                    mdtopdfviewerrefresh = 'none',
                    markdowntopdfviewerrefresh = "none",

                    -- Markdown to HTML
                    mdtohtml = 'pandoc --standalone %docroot% -o /tmp/%outputfile%',
                    markdowntohtml = 'pandoc --standalone %docroot% -o /tmp/%outputfile%',
                    mdtohtmlviewerlaunch = 'firefox -new-window /tmp/%outputfile%',
                    markdowntohtmlviewerlaunch = 'firefox -new-window /tmp/%outputfile%',
                    mdtohtmlviewerrefresh = 'none',
                    markdowntohtmlviewerrefresh = 'none',

                    -- LaTeX
                    -- TODO: stop from polluting workspace
                };

                -- F4 processes the document once, and refreshes the view
                vim.keymap.set({ 'n', 'v', 'i' }, '<F4>', function()
                    require('knap').process_once();
                end);

                -- F5 closes the viewer application, and
                -- allows settings to be reset
                vim.keymap.set({ 'n', 'v', 'i' }, '<F5>', function()
                    require('knap').close_viewer();
                end);

                -- F6 toggles the auto-processing on and off
                vim.keymap.set({ 'n', 'v', 'i' }, '<F6>', function()
                    require('knap').toggle_autopreviewing();
                end);

                -- F7 invokes a SyncTeX forward search, or similar,
                -- where appropriate
                vim.keymap.set({ 'n', 'v', 'i' }, '<F7>', function()
                    require('knap').forward_jump();
                end);
              '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./markdown.nix;
}
