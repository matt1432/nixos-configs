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

  # FIXME: https://pr-tracker.nelim.org/?pr=389338
  nuget-to-json = prev.nuget-to-json.overrideAttrs {
    src = prev.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/3180769c2e59a8e82a2dcd94eec2de2a8459783a/pkgs/by-name/nu/nuget-to-json/nuget-to-json.sh";
      hash = "sha256-BZR8WWzGNccgVGBBkpJbz+zCVgwpCmTSNdumN36JV10=";
    };
  };
}
