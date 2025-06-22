final: prev: {
  # FIXME: wait for next version of nix-update to reach nixpkgs (after 1.11.0)
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/ni/nix-update/package.nix
  nix-update = prev.nix-update.overrideAttrs (o: let
    inherit (builtins) fromTOML readFile substring;

    rev = "3d5866d1a8bc2f8197222e4814a8406298c36428";

    src = prev.fetchFromGitHub {
      owner = "Mic92";
      repo = "nix-update";
      inherit rev;
      hash = "sha256-y3LY2tWDQUDjraAOjQ60tgegAws1gpb+I5u06XmQnoA=";
    };

    pyproject = fromTOML (readFile "${src}/pyproject.toml");
  in {
    version = "${pyproject.project.version}+${substring 0 7 rev}";
    inherit src;
  });

  # FIXME: https://pr-tracker.nelim.org/?pr=418518
  waydroid = prev.waydroid.override {
    python3Packages = final.python312Packages;
  };

  # FIXME: https://pr-tracker.nelim.org/?pr=418139
  liburing = prev.liburing.overrideAttrs (o: rec {
    version = "2.11";
    src = final.fetchFromGitHub {
      owner = "axboe";
      repo = "liburing";
      tag = "liburing-${version}";
      hash = "sha256-V73QP89WMrL2fkPRbo/TSkfO7GeDsCudlw2Ut5baDzA=";
    };
  });

  # normal electron has a lot of cache misses for me
  electron = final.electron-bin;
}
