pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:bddc64a17aa38972f4c032f67efc3bf0a498883257e615a2d807ca44550cebf0";
  sha256 = "0wrs6vw4nbbcvjkyfbjbfbwwv1h77m2m6374jd59qffq5bpz1fw7";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
