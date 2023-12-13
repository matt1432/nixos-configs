{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-git";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "git";
    rev = "924d5fc32f7ca15d0dd3a8d2cf1747e81e063c73";
    hash = "sha256-3tKjKn5IHIByj+xgi2AIL1vZANlb0vlYJsPjH6BHGxM=";
  };

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
