{ pkgs, lib, ... }:
let
  # installs a vim plugin from git with a given tag / branch
  plugin = owner: repo: rev: hash: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = pkgs.fetchFromGitHub {
      inherit rev owner repo hash;
    };
  };
in
{
  xdg.configFile = {
    "../.gradle/gradle.properties".source = pkgs.writeText "gradle.properties" ''
      org.gradle.java.home = ${pkgs.temurin-bin-17}
    '';
  };
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    # read in the vim config from filesystem
    # this enables syntaxhighlighting when editing those
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents ../../config/nvim/base.vim)
    #  (lib.strings.fileContents ./.nvim/plugins.vim)
    #  (lib.strings.fileContents ./.nvim/lsp.vim)
      ''
        lua << EOF
        ${lib.strings.fileContents ../../config/nvim/config.lua}
        ${lib.strings.fileContents ../../config/nvim/lsp.lua}
        EOF
      ''
    ];

    extraPackages = with pkgs; [
      tree-sitter
      nodejs_latest
      gradle
      bat

      python311Packages.pylint
      nil
    ];

    coc = {
      enable = true;
      settings = {
        "colors.enable" = true;
        "coc.preferences.formatOnType" = true;
        "Lua.misc.parameters" = [
          "--metapath"
          "~/.cache/sumneko_lua/meta"
          "--logpath"
          "~/.cache/sumneko_lua/log"
        ];
        "sumneko-lua.serverDir" = "${pkgs.lua-language-server}/share/lua-language-server";
        "java.jdt.ls.java.home" = "${pkgs.temurin-bin-17}";
        "bashIde.shellcheckPath" = "${pkgs.shellcheck}/bin/shellcheck";
        languageserver = {
          nix = {
            command = "nil";
            filetypes = [ "nix" ];
            rootPatterns =  [ "flake.nix" ];
          };
        };
      };
    };
    plugins = with pkgs.vimPlugins; [
      vim-which-key

      coc-java
      coc-css
      coc-sumneko-lua
      coc-highlight
      coc-json
      coc-pyright
      coc-sh
      coc-snippets
      coc-vimlsp
      coc-yaml
      coc-toml
      coc-markdownlint
      coc-tsserver

      coc-fzf
      fzfWrapper
      fzf-vim

      nvim-treesitter.withAllGrammars
      nvim-treesitter
      nvim-autopairs

      dracula-nvim
      (plugin "lukas-reineke"
              "indent-blankline.nvim"
              "1e79f3dd6e750c5cb4ce99d1755a3e17025c0f47"
              "sha256-YhfMeA+bnXlGSZPNsK1rRls9iMXUlXYKVFjHwXlnE4E=")
      gitsigns-nvim
      lualine-nvim
      nvim-scrollbar

      neo-tree-nvim

      # to explore more
      fugitive
      todo-comments-nvim
    ];
  };
}
