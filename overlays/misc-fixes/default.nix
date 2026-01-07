final: prev: {
  wyoming-faster-whisper = prev.wyoming-faster-whisper.override {
    python3Packages =
      (final.python3.override {
        packageOverrides = pyFinal: pyPrev: {
          torch = pyFinal.torch-bin;
        };
      }).pkgs;
  };

  # FIXME: https://pr-tracker.nelim.org/?pr=477651
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-treesitter-textobjects = prev.vimPlugins.nvim-treesitter-textobjects.overrideAttrs (o: {
        dependencies = [final.vimPlugins.nvim-treesitter];
      });
    };
}
