pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:a6fc8ab9ff34d82327d29f8b5bfb7a672c0e54a274e5e5b023db01c335d05dfd";
  sha256 = "1fjjgsfybmqvwlk9r5ga5bnv31x003dacakhp6bp3w1glkbsjnra";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
