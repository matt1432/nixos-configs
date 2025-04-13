pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:5ad8df1b0dc0bb0c2232a9278b85c3c230d82184415f83238b5969da8dc6a942";
  hash = "sha256-9zF9IXm4lSh25W7iI8B4O+NoRpUVhWL5PaSa1MGhdgw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
