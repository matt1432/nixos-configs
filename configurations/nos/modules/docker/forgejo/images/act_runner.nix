pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c12e2f98996d5e6900ec33abff7d9601d565cd06e575c707dadb850154e67e57";
  hash = "sha256-L3VROLj1B+q1OMLyGI7A/NJShqxG49jxBlY8gEjhOJg=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
