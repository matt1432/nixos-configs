pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:23e88eb049fd5d54894d70100df61d38a49ed97909263f79d4ff4c30a5d5fca2";
  hash = "sha256-SWhSToPRB4OF3CXlimeWswOR4jO4mWGQEkiIs/z/2/o=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}
