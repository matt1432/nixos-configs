pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c1f9e2e8339642b32c8c8679b4d89058f3985699760fc7bc4e187a99f8549e86";
  sha256 = "042vf3s2nl3wvjhqvabxjl4k8fmkpshdsan0mpwhj7y8zilbycsg";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
