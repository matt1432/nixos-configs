pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:04ba374043ccd2fc5c593885c0eacddebabd5ca375f9323666f28dfd5a9710e3";
  sha256 = "12msgcrmwcdik735qy38iqp8k2jxxg2s75vy0cqkw6kjj2kr7x5g";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
