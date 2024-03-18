pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:d5cd4924a8806c5dac024b018ad902d4e426fbab7f72c53e06e448207d9f4bd1";
  sha256 = "0j099ym5fzahfp02bic39swj0ysj0abv1885y92c6fn7mmhk5b28";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
