pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:f0c1fe322671a5c4a302e27ee7aac622fb3c7ba6da231f6c378fe07ab900d6eb";
  sha256 = "03j08y9dwib44jhs4l95li33hydzk1i60jgnyncv3qn5cijnm1vn";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
