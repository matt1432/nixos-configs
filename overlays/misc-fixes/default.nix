final: prev: let
  inherit (final) lib;
in {
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

  # FIXME: https://pr-tracker.nelim.org/?pr=425299
  clisp = prev.clisp.overrideAttrs (o: let
    modules = lib.removePrefix ''bash ./clisp-link add "$out"/lib/clisp*/base "$(dirname "$out"/lib/clisp*/base)"/full'' o.postInstall;
  in {
    postInstall = lib.optionalString (modules != "") ''
      bash ./clisp-link add "$out"/lib/clisp*/base "$(dirname "$out"/lib/clisp*/base)"/full \
        ${modules}
      find "$out"/lib/clisp*/full -type l -name "*.o" | while read -r symlink; do
        if [[ "$(readlink "$symlink")" =~ (.*\/builddir\/)(.*) ]]; then
          ln -sf "../''${BASH_REMATCH[2]}" "$symlink"
        fi
      done
    '';
  });
}
