# https://breuer.dev/blog/nixos-home-manager-neovim
{ config, pkgs, lib, ... }:
let
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
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    # read in the vim config from filesystem
    # this enables syntaxhighlighting when editing those
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents ./.nvim/base.vim)
    #  (lib.strings.fileContents ./.nvim/plugins.vim)
    #  (lib.strings.fileContents ./.nvim/lsp.vim)
      ''
        lua << EOF
        ${lib.strings.fileContents ./.nvim/config.lua}
        ${lib.strings.fileContents ./.nvim/lsp.lua}
        EOF
      ''
    ];

    extraPackages = with pkgs; [
      tree-sitter

      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      nodePackages.bash-language-server
      shellcheck
      nixd
      sumneko-lua-language-server
      vscode-langservers-extracted
    ];
    plugins = with pkgs.vimPlugins; [
      vim-which-key

      nvim-treesitter.withAllGrammars
      nvim-treesitter

      #telescope-nvim
      #telescope-fzf-native-nvim
      
      (plugin "Mofiqul/dracula.nvim")
      (plugin "neovim/nvim-lspconfig")
      (plugin "lukas-reineke/indent-blankline.nvim")
      (plugin "lewis6991/gitsigns.nvim")
      (plugin "nvim-lualine/lualine.nvim")
      (plugin "elkowar/yuck.vim")

      # plugins for completion
      (plugin "hrsh7th/nvim-cmp")
      (plugin "hrsh7th/cmp-nvim-lsp")
      (plugin "hrsh7th/cmp-buffer")
      (plugin "hrsh7th/cmp-path")
      (plugin "hrsh7th/cmp-cmdline")
      (plugin "hrsh7th/cmp-vsnip")
      (plugin "hrsh7th/vim-vsnip")

      # neo-tree and deps
      (plugin "nvim-neo-tree/neo-tree.nvim")
      (plugin "nvim-lua/plenary.nvim")
      (plugin "nvim-tree/nvim-web-devicons")
      (plugin "MunifTanjim/nui.nvim")

      # to explore more
      (plugin "iamcco/markdown-preview.nvim")
      (plugin "sindrets/diffview.nvim")
      (plugin "windwp/nvim-autopairs")
      (plugin "mhartington/formatter.nvim")
      (plugin "folke/todo-comments.nvim")
      (plugin "petertriho/nvim-scrollbar")
    ];
  };
}
