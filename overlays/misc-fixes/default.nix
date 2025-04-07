final: prev: {
  # FIXME: https://github.com/Mic92/nix-update/pull/330
  nix-update = prev.nix-update.overrideAttrs (o: {
    version = o.version + "-mattpr";

    src = prev.fetchFromGitHub {
      owner = "matt1432";
      repo = "nix-update";
      rev = "30e33f8dc10b7452d6fa36f4c11cf61c2075ded6";
      hash = "sha256-Q7TJn1XEwGDaPZOvGdQ+B78e8mkZTtBrBVKngUCRABQ=";
    };
  });
}
