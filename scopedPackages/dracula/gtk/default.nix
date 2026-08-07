{
  pkgs,
  gtk-theme-src,
  ...
}: let
  inherit (pkgs.lib) attrValues tryEval warnIf;

  # NOTE: https://github.com/NixOS/nixpkgs/pull/548380
  dracula-theme = warnIf ((tryEval pkgs.dracula-theme).success) ''
    dracula-theme is back in nixpkgs
  '' (pkgs.callPackage ./package.nix {});
in
  dracula-theme.overrideAttrs (o: {
    version = o.version + "+" + gtk-theme-src.shortRev;
    src = gtk-theme-src;

    # Generate hyprcursor theme
    nativeBuildInputs =
      (o.nativeBuildInputs or [])
      ++ (attrValues {
        inherit
          (pkgs)
          hyprcursor
          xcur2png
          ;
      });

    preInstall = ''
      ${o.preInstall or ""}

      mkdir -p "$out/share/icons/Dracula-cursors"

      cd ./kde/cursors || return

      hyprcursor-util --extract ./Dracula-cursors

      # this creates a symlink to 'theme_Extracted Theme' for some reason
      hyprcursor-util --create ./extracted_Dracula-cursors
      mv 'theme_Extracted Theme' ./extracted

      cat <<EOF > ./extracted/manifest.hl
      name = Dracula-cursors
      description = Automatically extracted with hyprcursor-util
      version = 0.1
      cursors_directory = hyprcursors
      EOF

      mv ./extracted/* "$out/share/icons/Dracula-cursors/"
      cd ../..
    '';
  })
