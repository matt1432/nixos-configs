pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:58fca88cafda8915f45b780124c767d5b63b7a1194d4781edc8c4b7fb0d6e9c3";
  sha256 = "0dzvqrd7c2ajzi404qm3ziar31hyy5kpvjimdy9gxlpdz8mcd5wk";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
