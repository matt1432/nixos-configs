pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:f44f6955dc7a4e3b4dd4b07e56217b445d19287095744d06d63f84988fe76b6b";
  sha256 = "1303vgjlczc45ix7cnb1smghkxbnhkr7j6mnvpz84hm388rlalna";
  finalImageName = "ghcr.io/flaresolverr/flaresolverr";
  finalImageTag = "latest";
}
