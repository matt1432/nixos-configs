pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:1a50d4f08e283aa9ff4c723b940dceb4e8aeff7946e1993213efd0de3d5a4adb";
  sha256 = "0nz04zxvaq6xm7rx90n1d9639jqbw3n69b74g4a6nnjrac55n7g9";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
