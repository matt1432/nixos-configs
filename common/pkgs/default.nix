{...}: let
  mkPackage = name: (final: prev: {
    ${name} = final.callPackage ./${name} {};
  });
in {
  nixpkgs.overlays = [
    (mkPackage "coloryou")
    (mkPackage "input-emulator")
    (mkPackage "pam-fprint-grosshack")
    (mkPackage "spotifywm")
  ];
}
