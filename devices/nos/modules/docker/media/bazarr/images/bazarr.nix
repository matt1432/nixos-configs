pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:8573a7d8558d7407ec53c205599d99d9876486621681355d147e9091cd99c58b";
  sha256 = "07xzd0ca3kx7bx73qlswnd7r0z67xwqbb6s8y7d78jvgnb5d4pf8";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
