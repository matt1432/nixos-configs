pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:fbb15bb4fb14d1ffe017f6be0e3fed8f1b300e4687e329767da0b61f36ba1eed";
  hash = "sha256-q8cqV9puG5/rUEXM4/RRMINB906O5wvK4uLaIuGjlk4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
