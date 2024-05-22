pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:c255852b9a9f81d9ade5945222dddb0be00a85ef4fa6f9b18159b52a6f634893";
  sha256 = "1m7mszxvh6ndg5kdy1fxiksc4p6dxbbaynwxh86w0fa87q9m5jnl";
  finalImageName = "ghcr.io/flaresolverr/flaresolverr";
  finalImageTag = "latest";
}
