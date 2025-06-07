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

  # FIXME: https://github.com/neovim/nvim-lspconfig/issues/3892
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (o: rec {
    version = "0.11.1";
    src = final.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      tag = "v${version}";
      hash = "sha256-kJvKyNjpqIKa5aBi62jHTCb1KxQ4YgYtBh/aNYZSeO8=";
    };
  });

  # normal electron has a lot of cache misses for me
  electron = final.electron-bin;
}
