pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:7ab5769616c1929247c8e7944453253f0b777fac2724c3bc9976ae2ff4023257";
  hash = "sha256-cznmty5Ullh8fLxR9vjFVpfTNHOLhVVr5Cwx92W/4GY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
