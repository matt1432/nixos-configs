pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:42285de3376d0a7372553f2d6ec0f44f21f9a69239a9347151b005c7b126f7a5";
  sha256 = "1wsiss8iha2yl8hksq49iwfyx2vsx9fyw9rx1f77lq2r1i4ma6g7";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
