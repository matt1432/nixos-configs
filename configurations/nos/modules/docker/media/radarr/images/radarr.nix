pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:a360633a3682d41e96f71a07ff36ecbdf2394a9628465b84b0a8437087715b41";
  hash = "sha256-P1uXwKxmlDgPrStPcVMktKHWYwtE71Ev1uFveZT3qLI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
