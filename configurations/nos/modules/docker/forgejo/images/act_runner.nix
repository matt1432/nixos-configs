pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:68ae7e55fed3c2840183b2e301c70ce2c00fcb438396c9397d73c050623cf362";
  hash = "sha256-JjFPoaethCTRuHiM0SLMsAgynlzPKzHb7fBg//uNE7w=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
