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
      # used to compile tree-sitter grammar
      tree-sitter

      # https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      nodePackages.bash-language-server
      shellcheck
      nixd
    ];
    plugins = with pkgs.vimPlugins; [
      # you can use plugins from the pkgs
      vim-which-key
      clangd_extensions-nvim

      nvim-treesitter.withAllGrammars
      nvim-treesitter

      # or you can use our function to directly fetch plugins from git
      (plugin "hrsh7th/nvim-cmp") # completion
      (plugin "neovim/nvim-lspconfig")
      (plugin "Mofiqul/dracula.nvim")
      (plugin "nvim-neo-tree/neo-tree.nvim")

      # this installs the plugin from 'lua' branch
      (plugin "lukas-reineke/indent-blankline.nvim")
    ];
  };
}
