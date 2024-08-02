pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:8ea014ac2b7058c3a6a68df0cb0399a96c04438f1c9376dee1bbb6ec747ee7c1";
  sha256 = "1vi0h2pm0pcww65zij0pvhjvpw8nswd4nf5zvc4napalxq4w4chd";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
