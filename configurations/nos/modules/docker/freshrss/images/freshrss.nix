pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:ac8ba074707a020b1a865ae6671f17b6110068142484cee9f36df02ed6c41130";
  hash = "sha256-rqbyDdWggMx+9iE1v2KBziEqW+G1/YsXCD0ZmzMItjo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
