pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:5f5661db1e69a6f80ac24d47d9fa5580f6f741ee5ec967818396ae0dacecd7ea";
  sha256 = "04vl942nd3fk8y0fnnpsb293y7c4z6ph3dglmbsivjmahywwajk4";
  finalImageName = "ghcr.io/flaresolverr/flaresolverr";
  finalImageTag = "latest";
}
