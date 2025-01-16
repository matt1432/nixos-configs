pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:df53a7b06006e9da117a7072a55cf5d8b2071a6272f6bb329d8ca62b6f5c08a6";
  hash = "sha256-Za/VIS2FXRAB+SG02BMCkZ7jzRWOf2i3/X72z2sHgsI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
