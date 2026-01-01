pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:1d43c6754a030861f960fd4dab47e1b33fc19f05bd5f8f597ab7236465a6f14b";
  hash = "sha256-L1FrMCzkuSugk3wdgVwzt+BOfaYStyIB9jFVOyTSJxY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
