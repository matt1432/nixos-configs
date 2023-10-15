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

  programs = {

    java = {
      enable = true;
      package = pkgs.temurin-bin-17;
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      package = pkgs.neovim-nightly;

      extraConfig = builtins.concatStringsSep "\n" [
        (lib.strings.fileContents ./config/base.vim)
        ''
          lua << EOF
          ${lib.strings.fileContents ./config/config.lua}
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
        neodev-nvim

        coc-fzf
        fzfWrapper
        fzf-vim

        nvim-treesitter.withAllGrammars
        nvim-treesitter
        nvim-autopairs

        dracula-nvim
        (plugin "lukas-reineke"
                "indent-blankline.nvim"
                "0fe34b4c1b926e106d105d3ae88ef6cbf6743572"
                "sha256-e8gn4pJYALaQ6sGA66SFf8p6VLJBPxT/BimQhOd5eBs=")
        gitsigns-nvim
        lualine-nvim
        minimap-vim

        neo-tree-nvim

        # to explore more
        fugitive
        todo-comments-nvim
      ];
    };
  };
}
