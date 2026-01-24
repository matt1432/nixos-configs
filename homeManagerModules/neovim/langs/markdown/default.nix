self: {
  config,
  lib,
  osConfig,
  pkgs,
  self,
  ...
}: let
  inherit (self.inputs) vimplugin-easytables-src;
  inherit (self.lib.${pkgs.stdenv.hostPlatform.system}) buildPlugin;

  inherit (lib) concatStringsSep getExe mkIf optionalString;

  cfg = config.programs.neovim;
  isServer = osConfig.roles.server.sshd.enable or false;
  isDesktop = osConfig.roles.desktop.enable or false;

  githubCSS = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/OzakIOne/markdown-github-dark/5bd0bcf3ad20cf9f58591f97a597fd68fc699f8e/style.css";
    hash = "sha256-deQvQOOyK6iP7kjVrgEdFTyOP80RWXMrETs6gi7DTmo=";
  };
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        initLua =
          # lua
          ''
            loadDevShell({
                name = 'markdown',
                pattern = { 'markdown', 'tex' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    texlab = function(start)
                        start({
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
                    end,
                },
            });
          '';

        plugins = [
          {
            plugin = buildPlugin "easytables-nvim" vimplugin-easytables-src;
            type = "lua";
            config = ''
              require('easytables').setup();
            '';
          }

          {
            plugin = pkgs.vimPlugins.knap;
            type = "lua";
            config = let
              mdToPDF = "pandoc --css ${githubCSS} %docroot% -o /tmp/%outputfile%";
              mdToPDFViewer = "sioyek /tmp/%outputfile%";

              mdToHTML = "pandoc --standalone --embed-resource --highlight-style=breezedark --css ${githubCSS} %docroot% -o /tmp/%outputfile%";
              mdToHTMLViewer =
                if isServer && !isDesktop
                then
                  concatStringsSep " " [
                    (getExe pkgs.selfPackages.alive-server)
                    "--host=0.0.0.0"
                    "--port=6565"
                    "--quiet"
                    "--no-browser"
                    "--watch=%outputfile%"
                    "--entry-file=%outputfile%"
                    "--wait=800"
                    "/tmp"
                  ]
                else "firefox -new-window /tmp/%outputfile%";
            in
              # lua
              ''
                vim.g.knap_settings = {
                    -- HTML
                    htmloutputext = 'html',
                    htmltohtml = 'none',
                    htmltohtmlviewerlaunch = 'true',
                    htmltohtmlviewerrefresh = 'none',

                    -- Markdown
                    mdoutputext = 'html',
                    markdownoutputext = 'html',

                    -- Markdown to PDF
                    mdtopdf = '${mdToPDF}',
                    markdowntopdf = '${mdToPDF}',
                    mdtopdfviewerlaunch = '${mdToPDFViewer}',
                    markdowntopdfviewerlaunch = '${mdToPDFViewer}',
                    mdtopdfviewerrefresh = 'none',
                    markdowntopdfviewerrefresh = 'none',

                    -- Markdown to HTML
                    mdtohtml = '${mdToHTML}',
                    markdowntohtml = '${mdToHTML}',
                    mdtohtmlviewerlaunch = '${mdToHTMLViewer}',
                    markdowntohtmlviewerlaunch = '${mdToHTMLViewer}',
                    mdtohtmlviewerrefresh = 'none',
                    markdowntohtmlviewerrefresh = 'none',

                    -- LaTeX
                    texoutputext = 'pdf',
                    textopdf = 'cp -rf %docroot% /tmp/%docroot%; pdflatex -interaction=batchmode -halt-on-error -synctex=1 /tmp/%docroot%',
                    textopdfviewerlaunch = 'sioyek --inverse-search \'nvim --headless -es --cmd "lua require(\'"\'"\'knaphelper\'"\'"\').relayjump(\'"\'"\'%servername%\'"\'"\',\'"\'"\'%1\'"\'"\',%2,%3)"\' --new-window /tmp/%outputfile%',
                    textopdfviewerrefresh = 'none',
                    textopdfforwardjump = 'sioyek --inverse-search \'nvim --headless -es --cmd "lua require(\'"\'"\'knaphelper\'"\'"\').relayjump(\'"\'"\'%servername%\'"\'"\',\'"\'"\'%1\'"\'"\',%2,%3)"\' --reuse-window --forward-search-file %srcfile% --forward-search-line %line% /tmp/%docroot%/%outputfile%',
                    textopdfshorterror = 'A=/tmp/%outputfile% ; LOGFILE="''${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
                };

                ${optionalString (isServer && !isDesktop)
                  # lua
                  ''
                    vim.api.nvim_create_autocmd('BufUnload', {
                        pattern = '*',
                        callback = function()
                            os.execute('${pkgs.psmisc}/bin/killall -qr live-server');
                        end,
                    });
                  ''}

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
  _file = ./default.nix;
}
