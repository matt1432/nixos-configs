pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:fe72f4b341fa5c3275826a39aebfff23cbd552c956b0ab2d51dfba6a49b528f8";
  hash = "sha256-gwkU2gNM8/V5b/z8I5k7Jo25ydLknUj4GF3MCuY+XS0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
