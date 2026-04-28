pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:c77e5d7912f9b137cc67051fdc2991d8f5ae22c55ddf532bb836dcb693a04940";
  hash = "sha256-ByuMMuAaRKJzCrA+jMW6cLTJl4mp0I2pGzjDzE475VE=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
