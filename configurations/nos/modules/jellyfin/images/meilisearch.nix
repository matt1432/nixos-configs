pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:71cdfc95cbbe20e99e430f9c955a52f6530833ed25041710fa0b04f8128cfbb3";
  hash = "sha256-lLN6Mjao1jHCjkoXmK8a0bfRhocG4nG+ViXRxKZGLPw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
