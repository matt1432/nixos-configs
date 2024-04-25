pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:f97e2bfadc0a094703428af69a7bbc659a4ed634cb841f7b0109981509e5ef29";
  sha256 = "1478d9343m8agn704xggbgfiq12z0bzl14n5dvgkn1zwbw3gi1ch";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
