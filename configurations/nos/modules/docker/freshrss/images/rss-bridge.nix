pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:3d151be86e9b8935ee184670b3a1e0809316a3be0b9656d0c749b3dae458d09a";
  hash = "sha256-JOTH0arcTRvn+yoZIb8f/pKp2yNTQJzDbwmY977N01c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
