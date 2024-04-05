pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:84d434018691fa9af36a7629a72f0cc886885f2c0bbca645b2e307d85abfca2e";
  sha256 = "1rc2l535rkc92ghp2xxfk4k1zwbgiv7v4fx6qx3888hm80pvc27w";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
