pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:7de8fd442afc26e4932a0b2521e2eec82db9f17667eef7b46fd9c2fa2e639de2";
  sha256 = "07scp48xbvhz1y7m6sfq2s2s9pij6kj94ngs8ypdj41kxqmnrk6s";
  finalImageName = imageName;
  finalImageTag = "latest";
}
