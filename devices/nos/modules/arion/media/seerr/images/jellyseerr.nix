pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:aa0c5261afddceab7d4a814647ff591427515b73de9c883f93ea37d846f81fe6";
  sha256 = "1p7z9ah96mnq86nncsd811m03lpg8wnv4cl468nf13c32jjay2s9";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
