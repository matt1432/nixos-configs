final: prev: {
  # FIXME: do some other stuff and make PR
  nix-update = prev.nix-update.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "matt1432";
      repo = "nix-update";
      rev = "21de1ebd7e7c22de03f0a9c7e1f6cd488fa96d03";
      hash = "sha256-ukapzy0+mS4rorX3D22lRKX/D9TXmkq8W2YNDQIq7A8=";
    };
  });

  # FIXME: automate this or make PR for nixpkgs-wayland?
  fcft = prev.fcft.overrideAttrs (o: rec {
    version = "3.3.0";

    src = prev.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "fcft";
      rev = version;
      hash = "sha256-spK75cT6x0rHcJT2YxX1e39jvx4uQKL/b4CHO7bon4s=";
    };
  });
}
