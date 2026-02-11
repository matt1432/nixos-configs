pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:1ca2e2098ba9ab9e46004f4ee61a3be6080ffee3ed41018a95c4b0fb6454a54b";
  hash = "sha256-/TG/NZwzE1WG4xTGC/pUs6VhZBBzwV6JEJCFX6tFmTc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
