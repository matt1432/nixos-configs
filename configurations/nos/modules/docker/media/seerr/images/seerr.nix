pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:d8fab675b55ad293ded98fd71efcfd46054cbad9746534ae1cc4794a88c0b3be";
  hash = "sha256-jrFaZZgoYh/X650dG22kyeXV2YrypDxTjCzOdCeW8J4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
