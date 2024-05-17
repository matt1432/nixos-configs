pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:60239081482ffccf53db88dacf71349e09651fe353fe6cf6592ded75f6ddcdee";
  sha256 = "0fvcfq8gim7pfvw261j0hjyx6csdymrha0dmwvxayy032d5wn6ii";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
