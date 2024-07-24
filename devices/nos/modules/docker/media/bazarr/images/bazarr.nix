pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:5da74fc1bbd5da69e3b4f9b2376f6ccfbe3b47f143e6eb5651ed37cc1d4412dd";
  sha256 = "0k72wmxp4hfy9v1l6bjlrrhg6q5knlg6h48mvbw3y9sg2hy95kvp";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
