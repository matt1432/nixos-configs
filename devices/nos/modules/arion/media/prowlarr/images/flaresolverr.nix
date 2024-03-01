pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:088412db1051d04ab32c902266510011aec1dc9f7a3a3bda3f58b93186591347";
  sha256 = "1x3s1qvzjz9kbxs829dyjp2m1fabmcvvi1n5z56j0dh1s0vcpb20";
  finalImageName = "ghcr.io/flaresolverr/flaresolverr";
  finalImageTag = "latest";
}
