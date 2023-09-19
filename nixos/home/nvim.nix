# https://breuer.dev/blog/nixos-home-manager-neovim
{ config, pkgs, lib, ... }:
let
  configDir = "/home/matt/.nix/config";
  
  # installs a vim plugin from git with a given tag / branch
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  # always installs latest version
  plugin = pluginGit "HEAD";
in {
  xdg.configFile = {
    "nvim/coc-settings.json".source = pkgs.writeText "coc-settings.json" ''
      {
        "java.jdt.ls.java.home": "${pkgs.temurin-bin-18}",
        "colors.enable": true,
        "Lua.misc.parameters": [
          "--metapath",
          "~/.cache/sumneko_lua/meta",
          "--logpath",
          "~/.cache/sumneko_lua/log"
        ],
        "sumneko-lua.serverDir": "${pkgs.lua-language-server}/share/lua-language-server"
      }
    '';
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    # read in the vim config from filesystem
    # this enables syntaxhighlighting when editing those
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents "${configDir}/nvim/base.vim")
    #  (lib.strings.fileContents ./.nvim/plugins.vim)
    #  (lib.strings.fileContents ./.nvim/lsp.vim)
      ''
        lua << EOF
        ${lib.strings.fileContents "${configDir}/nvim/config.lua"}
        ${lib.strings.fileContents "${configDir}/nvim/lsp.lua"}
        EOF
      ''
    ];

    extraPackages = with pkgs; [
      tree-sitter
      nodejs_latest
      bat
    ];
    plugins = with pkgs.vimPlugins; [
      vim-which-key

      coc-nvim # done
      coc-java # done
      coc-css # done
      coc-sumneko-lua # done
      coc-highlight # done
      coc-json
      coc-pairs
      coc-python
      coc-sh
      coc-snippets
      coc-vimlsp
      coc-yaml
      coc-toml

      coc-fzf
      (plugin "junegunn/fzf.vim")
      (plugin "junegunn/fzf")

      nvim-treesitter.withAllGrammars
      nvim-treesitter

      (plugin "Mofiqul/dracula.nvim")
      (plugin "lukas-reineke/indent-blankline.nvim")
      (plugin "lewis6991/gitsigns.nvim")
      (plugin "nvim-lualine/lualine.nvim")

      # neo-tree and deps
      (plugin "nvim-neo-tree/neo-tree.nvim")
      (plugin "nvim-lua/plenary.nvim")
      (plugin "nvim-tree/nvim-web-devicons")
      (plugin "MunifTanjim/nui.nvim")

      # to explore more
      (plugin "iamcco/markdown-preview.nvim")
      (plugin "sindrets/diffview.nvim")
      (plugin "folke/todo-comments.nvim")
      (plugin "petertriho/nvim-scrollbar")
    ];
  };
}
