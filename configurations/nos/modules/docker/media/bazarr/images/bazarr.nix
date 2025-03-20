pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:fffd75389760b731f11468a1ddabcb35b042ef4b51994c9587337825cdef5470";
  hash = "sha256-Tcjo1N/TptoyLI5Kt6leESEq6wbJW9pSEPzGX3DJ/SA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
