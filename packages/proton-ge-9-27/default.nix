{
  # nix build inputs
  fetchzip,
  # deps
  proton-ge-bin,
  ...
}:
proton-ge-bin.overrideAttrs (o: rec {
  version = "9.27";

  src = fetchzip {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    hash = "sha256-70au1dx9co3X+X7xkBCDGf1BxEouuw3zN+7eDyT7i5c=";
  };

  preFixup = null;
})
