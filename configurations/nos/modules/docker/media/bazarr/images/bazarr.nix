pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a42fef2a5ffa1dca8714e12892ba0b8de5c6c513f1bcdb1ffe4143e715cffb45";
  hash = "sha256-bFHsaGLWW5cyi8+q7TYwhjnErBN5SL7h6QLDCMIzjm0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
