pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "tensorchord/pgvecto-rs";
  imageDigest = "sha256:739cdd626151ff1f796dc95a6591b55a714f341c737e27f045019ceabf8e8c52";
  hash = "sha256-OOY889BAihJ7pIJ0wPvWoaCrKzalTJXdYnXRYtVkCpc=";
  finalImageName = imageName;
  finalImageTag = "pg14-v0.2.0";
}
