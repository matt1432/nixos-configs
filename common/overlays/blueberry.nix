final: prev: {
  blueberry = prev.blueberry.overrideAttrs (o: {
    patches =
      (o.patches or [])
      ++ [
        ./patches/wayland.patch
      ];
    buildInputs =
      (o.buildInputs or [])
      ++ [
        prev.libappindicator
      ];
  });
}
