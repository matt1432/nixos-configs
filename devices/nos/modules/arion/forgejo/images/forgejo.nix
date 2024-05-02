pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:051873492dba166694d173d788ebc1cddff9b447658a55f3dfba8a9076ae39db";
  sha256 = "1jb9hn7485ba92yvwmhq5a2kz4wr6fdb8m035lzgcng9xqchmnp9";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7.0.2";
}
