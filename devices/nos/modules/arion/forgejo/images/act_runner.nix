pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:d9fc651a23753d162efbea320990cae5c605062843a8845a4a8449d5efe100ae";
  sha256 = "10xwjwif09zl9c1dim5q9vzn7lkzxbfp0w2yqijm6w4p8pgaqgfz";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
