pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:32e76d4f34f80e479964a0fbd4c5b4f6967b5322c8d004e9cf0cb81c93510766";
  sha256 = "0chbi30iwgsb5ahnhwcmk40wckpyiskmk6xdmf3i7bmx876b7mnk";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
