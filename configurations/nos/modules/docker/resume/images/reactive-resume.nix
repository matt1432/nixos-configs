pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:267e56e622f39b226e3796331e7391dad6ac9bc8c4369a506f33cd5876f26b36";
  hash = "sha256-bSvaB5tnnq0Mu50kPy3vSTuZ03GQsuxFGQ0dyRAWJ7k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
