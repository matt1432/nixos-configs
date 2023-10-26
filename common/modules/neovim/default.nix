# Home-manager module

{ pkgs, lib, ... }: let
  # installs a vim plugin from git with a given tag / branch
  plugin = owner: repo: rev: hash: pkgs.vimUtils.buildVimPlugin {
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

  home.packages = with pkgs; [
    gradle
    gradle-completion # FIXME: not working
  ];

  programs = {

    java = {
      enable = true;
      package = pkgs.temurin-bin-17;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      package = pkgs.neovim-nightly;

      extraConfig = with lib.strings; ''
        ${fileContents ./config/base.vim}
      '';

      extraLuaConfig = with lib.strings; ''
        ${fileContents ./config/config.lua}
      '';

      withNodeJs = true;
      extraPackages = with pkgs; [
        nodejs_latest
        nodePackages.npm
        nodePackages.neovim
        gradle

        bat

        stylelint
        nil
      ];
      extraPython3Packages = with pkgs.python311Packages; [
        pylint
      ];

      coc = {
        enable = true;
        settings = {
          "colors.enable" = true;
          "coc.preferences.formatOnType" = true;
          "inlayHint.enable" = false;

          "eslint.format.enable" = true;
          "eslint.autoFixOnSave" = true;
          "stylelintplus.autoFixOnFormat" = true;
          "css.validate" = false;
          "less.validate" = false;
          "scss.validate" = false;
          "wxss.validate" = false;

          "Lua.misc.parameters" = [
            "--metapath"
            "~/.cache/sumneko_lua/meta"
            "--logpath"
            "~/.cache/sumneko_lua/log"
          ];
          "Lua.workspace.library" = [
            "$\{3rd\}/luv/library"
          ];
          sumneko-lua = {
            serverDir = "${pkgs.lua-language-server}/share/lua-language-server";
            enableNvimLuaDev = true;
          };

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
        coc-eslint
        (plugin "bmatcuk"
                "coc-stylelintplus"
                "4854bfdc0cb6f92e39b5afb3b90d60b411ecb9e4"
                "sha256-PgcQc3JecfHE4oNcydyOqsKdRbh4yPhXPugVQDGSRuI=")
        neodev-nvim

        coc-fzf
        fzfWrapper
        fzf-vim

        nvim-treesitter
        nvim-treesitter.withAllGrammars
        nvim-autopairs

        dracula-nvim
        (plugin "lukas-reineke"
                "indent-blankline.nvim"
                "046e2cf04e08ece927bacbfb87c5b35c0b636546"
                "sha256-bhoep8aTYje5K/dZ/XmpwBPn4PBEMPrmw33QJdfFe6M=")
        gitsigns-nvim
        lualine-nvim
        (plugin "echasnovski"
                "mini.map"
                "75b7ca9443e17c852b24055b32f74a880cf48053"
                "sha256-CoMc6yQXXAW1wzcD9eJGuM+kcOJghuwHjKrqEMxZBec=")

        neo-tree-nvim

        # to explore more
        fugitive
        todo-comments-nvim
      ];
    };
  };
}
