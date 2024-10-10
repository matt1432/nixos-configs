pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "21hsmw/flaresolverr";
  imageDigest = "sha256:a85e675e7b4e980e142d58e440dd3e1b6fa6bc10aabcc612727f81e34c28db80";
  sha256 = "1wn32jl4za7y4sj5ljz5m87z46maz65c4ckznz84mp15f008c5y4";
  finalImageName = imageName;
  finalImageTag = "nodriver";
}
