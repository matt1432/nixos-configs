pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:ea775bc8c1911ff5b51c6a1199c266032e6fd406d28199b2f188b6073c6b1c64";
  sha256 = "1jr8yl8bk21ahcydfsxk5mlzqhapx8yzkh9h4qcmzrg50xdq0y9i";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
