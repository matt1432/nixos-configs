pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:cb57afc3bd35558e1e7062658f9d4d18a0b4c474f10afe55f0ccfd867025f24f";
  hash = "sha256-eXUBwGrLptMX5WJMkgq/Cw1jEMm1yXVOyZ9SypQPHrk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
