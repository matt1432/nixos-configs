pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:47acec85a0d92d107096088aebe83d1d0a434def34e5bac317fff18ca28741ae";
  sha256 = "1ad420vn49kj4igl9c88bl9cdwylcqdbmc947zr1cgf8h1w3igh0";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
