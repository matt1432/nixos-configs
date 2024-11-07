pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:61c937fd19ead374764f7a00f3e284521b5d0eea8edef6761276e3cd06bf4a9a";
  sha256 = "032hx148m1anhzkz7sskxx44kzkmfl56y8bsbh4k378gr7h2y8ij";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
