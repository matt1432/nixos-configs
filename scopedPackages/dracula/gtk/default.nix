{
  pkgs,
  gtk-theme-src,
  ...
}:
pkgs.dracula-theme.overrideAttrs (o: {
  version = o.version + "+" + gtk-theme-src.shortRev;
  src = gtk-theme-src;

  # Generate hyprcursor theme
  buildInputs =
    (o.buildInputs or [])
    ++ (builtins.attrValues {
      inherit
        (pkgs)
        hyprcursor
        xcur2png
        ;
    });

  preInstall = ''
    ${o.preInstall or ""}

    mkdir -p $out/share/icons/Dracula-cursors

    cd ./kde/cursors

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

    mv ./extracted/* $out/share/icons/Dracula-cursors/
    cd ../..
  '';
})
