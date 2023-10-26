{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  name = "stylelint-lsp";
  pname = "stylelint-lsp";

  src = fetchFromGitHub {
    owner = "matt1432";
    repo = pname;
    rev = "279a4a5c53e79b7f7cbb6bdf60cca5ed8135c0a2";
    hash = "sha256-myQ2jr+XY/fKuT2NE29OZd4uJZlfWFGbxnUr1SUZEW0=";
  };

  npmDepsHash = "sha256-P8S6EO//6daUYKQ3GTZDmwah7KD0+mRyhy2ruFERx0I=";

  dontNpmBuild = true;
  makeCacheWritable = true;
}
