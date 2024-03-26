{
  stdenv,
  git-theme-src,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-git";
  version = git-theme-src.shortRev;

  src = git-theme-src;

  installPhase = ''
    # Git colors
    cp -a ./config/gitconfig ./git-colors
    chmod 777 ./git-colors

    line=$(grep -n 'Dracula Dark Theme' ./git-colors | cut -d: -f1)
    sed -i "1,$((line-1))d" ./git-colors

    mkdir $out
    cp -a ./git-colors $out
  '';
}
