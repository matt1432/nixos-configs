pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:7fe570255a762fe4c183be06bcb58f0a5718605a24bd4a87ef32fc6e8ea8657d";
  sha256 = "04nmd9jk8py5phgp9nv2a5b36xmvw94a6qc24k6bbpkjp59f7ydq";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
