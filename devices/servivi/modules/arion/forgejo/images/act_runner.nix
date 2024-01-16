pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:3365bb367c7f45fd00a0bc229effa616bc167fd8215a558ba1123a8f05dfaf9a";
  sha256 = "1q3gr55z08prf0531889sa4i6g07mlpnw7lsjb7vz3yn0jmh3jpz";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
