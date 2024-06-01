{
  config,
  pkgs,
  lib,
  vimplugin-easytables-src,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;

  buildPlugin = pname: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.shortRev;
    };
in
  lib.mkIf neovimIde {
    programs = {
      # TODO: add syntax highlighting for markdown
      sioyek = {
        enable = true;

        config = let
          # TODO: put this with the rest of the themes
          dracula-theme = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "sioyek";
            rev = "b832ab04d880fbe243c0fe9043612be61226426e";
            hash = "sha256-+HzxZA8Bb+cGogK+w4JES4ZFG+ueXEAuLu+0T18fvbc=";
          };
        in {
          startup_commands = "toggle_custom_color";
          # TODO: make sure the font is applied
          ui_font = "JetBrainsMono Nerd Font Mono Regular";
          font_size = "24";
          source = "${dracula-theme}/dracula.config";
        };
      };

      neovim = {
        extraPackages = [
          pkgs.pandoc

          # LaTeX packages
          pkgs.texlab
          pkgs.texliveFull
          pkgs.rubber
        ];

        extraLuaConfig =
          /*
          lua
          */
          ''
            local lsp = require('lspconfig');
            local coq = require('coq');

            lsp.texlab.setup(coq.lsp_ensure_capabilities({}));
          '';

        plugins = [
          {
            plugin = buildPlugin "easytables-nvim" vimplugin-easytables-src;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                require('easytables').setup();
              '';
          }

          {
            plugin = vimPlugins.knap;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                local gknapsettings = {
                    -- HTML
                    htmloutputext = "html",
                    htmltohtml = "none",
                    htmltohtmlviewerlaunch = "",
                    htmltohtmlviewerrefresh = "none",

                    -- Markdown
                    mdoutputext = 'pdf',
                    markdownoutputext = 'pdf',
                    mdtopdf = 'pandoc %docroot% -o /tmp/%outputfile%',
                    markdowntopdf = "pandoc %docroot% -o /tmp/%outputfile%",
                    mdtopdfviewerlaunch = 'sioyek /tmp/%outputfile%',
                    markdowntopdfviewerlaunch = "sioyek /tmp/%outputfile%",
                    mdtopdfviewerrefresh = 'none',
                    markdowntopdfviewerrefresh = "none",
                    mdtohtml = "",
                    markdowntohtml = "",
                    mdtohtmlviewerlaunch = "",
                    markdowntohtmlviewerlaunch = "",
                    mdtohtmlviewerrefresh = 'none',
                    markdowntohtmlviewerrefresh = 'none',

                    -- LaTeX
                    -- TODO: stop from polluting workspace
                };

                vim.g.knap_settings = gknapsettings;

                local kmap = vim.keymap.set

                -- F4 processes the document once, and refreshes the view
                kmap({ 'n', 'v', 'i' }, '<F4>', function()
                    require('knap').process_once();
                end);

                -- F5 closes the viewer application, and
                -- allows settings to be reset
                kmap({ 'n', 'v', 'i' }, '<F5>', function()
                    require('knap').close_viewer();
                end);

                -- F6 toggles the auto-processing on and off
                kmap({ 'n', 'v', 'i' }, '<F6>', function()
                    require('knap').toggle_autopreviewing();
                end);

                -- F7 invokes a SyncTeX forward search, or similar,
                -- where appropriate
                kmap({ 'n', 'v', 'i' }, '<F7>', function()
                    require('knap').forward_jump();
                end);
              '';
          }
        ];
      };
    };
  }
