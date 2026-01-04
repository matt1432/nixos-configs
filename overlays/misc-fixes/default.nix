final: prev: {
  wyoming-faster-whisper = prev.wyoming-faster-whisper.override {
    python3Packages =
      (final.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          torch = pyFinal.torch-bin;
        };
      }).pkgs;
  };

  # FIXME: https://pr-tracker.nelim.org/?pr=475611
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-treesitter-textobjects = prev.vimUtils.buildVimPlugin {
        pname = "nvim-treesitter-textobjects";
        version = "0-unstable-2025-12-27";
        src = prev.fetchFromGitHub {
          owner = "nvim-treesitter";
          repo = "nvim-treesitter-textobjects";
          rev = "ecd03f5811eb5c66d2fa420b79121b866feecd82";
          hash = "sha256-mMxCAkrGqTstEgaf/vwQMEF7D8swH3oyUJtaxuXzpcs=";
        };
        meta.homepage = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects/";
        meta.hydraPlatforms = [];
      };
    };
}
