pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:fc2a6a3c68db8857934a51f6bf641110a45aaa2a15c7f5ee805548320f50fc77";
  sha256 = "03428y28hzvwrfipvvfdaphri47gslr7ha7lz28yzkgq9clcm2dr";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
