pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:4cb51f15113a3448daae197525e026d2a2cf7aac8336c27404100d48d90e7926";
  hash = "sha256-ljNLJLHuNlAS3afhkN2m/LX9sc8Q+4vbzshoQ0ytj5U=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
