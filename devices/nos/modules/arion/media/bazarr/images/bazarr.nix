pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:2268b45c0b9f6b978eb75b7955459682659e146e18a3cb057e9656ea3dd80600";
  sha256 = "0yy3zrpahx7f3x7b6sx35qhg9xw07jjmp55sl02bjp8cmkrqn5bc";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
