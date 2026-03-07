pkgs: {
  version = "1.1.0";
  src = pkgs.fetchFromGitHub {
    repo = "nix-serve-ng";
    owner = "aristanetworks";
    rev = "8ce0104efdf7f72e5a371bc48613084673b23cc0";
    hash = "sha256-Pck7/jhaoYAUM9M0nWR/dwYEVwXXNP2bzB4+XtZBmno=";
  };
}
