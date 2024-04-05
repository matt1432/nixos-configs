pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:91f7199dc40ccb1ef6667e3f834bbc2c64ade9a25ec3941f6d5d908bddcd145e";
  sha256 = "18pbdw6ivchk2fwh8h7w91jl3zcr02zfqcf44adb0bvf1dziw30x";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
