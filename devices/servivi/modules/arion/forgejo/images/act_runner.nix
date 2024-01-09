pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:cebdf60a65a2bba2e3d59d906f65ee45c05643cb5ee74be4d2a73a93708084cd";
  sha256 = "1pfbad0k719s094qhmcy2kmnvsjvllzr19cnx5jlf9cfm9cglvr1";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
