final: prev: {
  squeekboard = prev.squeekboard.overrideAttrs (o: {
    patches =
      (o.patches or [])
      ++ [
        ./patches/remove-panel.patch
      ];
  });
}
