pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:454a6a361d473e699bbccebee488b3886048eed91e2058657b9ba398ce917a77";
  hash = "sha256-9mciHd4VWMoVpr/KRqigJxOGijmh9XkK0lxwkNPNyQk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
