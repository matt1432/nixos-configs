pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:9a98da4fb506278ce92c2fdbb4e08a38418dd1456e3dd8b3a1f00a42a8ec4fb0";
  sha256 = "0c837grrq3mcc5qhgqfgckjvv6bj0mn7irnjcsrhrjzdklliw8b5";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
