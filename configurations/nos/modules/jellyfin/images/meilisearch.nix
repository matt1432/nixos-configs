pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:0c2c2b954bfc230fd54334e9dcc77601eb182d0eb5b6885ce21724525e678bf9";
  hash = "sha256-OEdYLuUMvNTi2TSc0rhIipKSZUzO4o6QLWV0/WxGtso=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
