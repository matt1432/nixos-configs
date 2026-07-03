pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:635ffcb7cfb09375622b56ee7ba0e4aed6246cef37e59efef36dbacb9cfbfc8e";
  hash = "sha256-lFteRnLdnEPOAEDuZePcwPdzVNukAb14xIw33kU5yK4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
