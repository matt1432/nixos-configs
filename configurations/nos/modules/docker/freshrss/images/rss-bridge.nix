pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a23fe03cbb57d473c9f53d6f51eb4cfd4cfe005e435167795014ed7a7a572a3d";
  hash = "sha256-ZkyqlmLbQEStx2S7Am/OxPUUlog6+W/s/+q7/lPgzbY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
