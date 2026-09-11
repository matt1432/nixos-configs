pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c7502a75b021d964481c129c84590b9cbc40f83aadd4e553f173871bc0deaa3c";
  hash = "sha256-CmBAfXqhJo8CuSCVQszxae/5UMaEFhPjXLwaZjdyneE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
