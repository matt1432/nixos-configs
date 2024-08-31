{
  gtk-theme-src,
  mkVersion,
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-hyprcursor";
  version = mkVersion gtk-theme-src;

  src = "${gtk-theme-src}/kde/cursors";

  buildInputs = builtins.attrValues {
    inherit
      (pkgs)
      hyprcursor
      xcur2png
      ;
  };

  installPhase = ''
    hyprcursor-util --extract ./Dracula-cursors
    hyprcursor-util --create ./extracted_Dracula-cursors

    cat <<EOF > ./extracted_Dracula-cursors/manifest.hl
    name = Dracula-cursors
    description = Automatically extracted with hyprcursor-util
    version = 0.1
    cursors_directory = hyprcursors
    EOF

    mv 'theme_Extracted Theme' $out
  '';
}
