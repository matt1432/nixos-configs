pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:afd005e6e065913e9e20e3ac098decf3f79495f3300215acf03f2537a6c0ac6a";
  sha256 = "0p9w1bvbpdyj1fhkz43jzi5mrjjr3mbivbcsngvhks8nbksi3fiq";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
