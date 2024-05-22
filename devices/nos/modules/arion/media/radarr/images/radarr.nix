pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:b84ed4a003c459df9675198e64053a2e9c0a3d5dd76587415b16c6902b8543f2";
  sha256 = "1sjgv1xf3b0zs0nmvk1srhw361kz3c7a85swr9d0zky7pm16igpz";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
