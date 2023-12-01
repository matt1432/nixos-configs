final: prev: {
  blueberry = prev.blueberry.overrideAttrs (o: {
    patches =
      (o.patches or [])
      ++ [
        ./wayland.patch
      ];
    buildInputs =
      (o.buildInputs or [])
      ++ [
        prev.libappindicator
      ];
  });
}
