pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:33ddda92b3f02bbd38a452b44f7343da25ada4c374fbac50c656bc04b995d93f";
  sha256 = "1qylqqbngqxsl87jr7ks9pnkjnchy7jinkdc3y5ch7vxrml1919r";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
