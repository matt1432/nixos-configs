{
  stdenv,
  git-theme-src,
  ...
}:
stdenv.mkDerivation {
  pname = "dracula-git";
  version = git-theme-src.shortRev;

  src = git-theme-src;

  installPhase = ''
    chmod 777 ./config/gitconfig

    # Remove every line above 'Dracula Dark Theme'
    line=$(grep -n 'Dracula Dark Theme' ./config/gitconfig | cut -d: -f1)
    sed -i "1,$((line-1))d" ./config/gitconfig

    cat ./config/gitconfig > $out
  '';
}
