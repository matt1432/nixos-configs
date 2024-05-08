pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:43a3ee88abe3b37c64bc52ea93da01c3dcb4a332a953bcd7f438c8d7328d3947";
  sha256 = "0gg2yn5yhd8l0misq8avnr765rxci0hy2ml3lw7jq7fkwsc4pw6s";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
