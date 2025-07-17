pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:acae57fe68c7cb85bbaebdb24158851d9d72b79f4e403f6ede4e9a03194202df";
  hash = "sha256-SvmO0zH7poWK+FMzlEMb5Mp0zFGFpqb7w7IpFK1YB+Y=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
