pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:c0281bd62b9a75f088fa4a09e5f8776431921883766633cb5e5fbd5a74761155";
  sha256 = "0bd1hpf4z5vhjgz5fraqav1ig1a522y93kylvin5dmw9zvzv90zy";
  finalImageName = imageName;
  finalImageTag = "latest";
}
