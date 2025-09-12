pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/thephaseless/byparr";
  imageDigest = "sha256:dd2ab939fd616c17da5f58d85f5264e5ad125de1db732f3f27a4b52e96b78cbb";
  hash = "sha256-HadzwFl8cYMEkeoiyY64kZ/wKooMtsMx6C6LLjBbEDE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
