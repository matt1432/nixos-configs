pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:68efaf4f9a6ea072b68e1a8a2925fdc00f931fb1c699d969cae9c16f394b1411";
  sha256 = "1vbd8j72hy9l5qmqlspx213p230gd0g318nq9sysgq5rqgrk9h28";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
