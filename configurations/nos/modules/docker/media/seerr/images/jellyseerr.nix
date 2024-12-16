pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:af5563771964282e5bfb6a4f30b05c75c8d30661a920f0399086f575217d0573";
  sha256 = "17capaw79rdvc5svfyqy5v9jd9l6hifx6ga3vybd667zgv8dssvm";
  finalImageName = imageName;
  finalImageTag = "latest";
}
