final: prev: {
  squeekboard = prev.squeekboard.overrideAttrs (o: {
    patches =
      (o.patches or [])
      ++ [./remove-panel.patch];
  });
}
