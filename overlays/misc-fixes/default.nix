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
}
