pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:d1071eb21edbb477b2d93dda5c8ba4e0aa471ee73e4e52776389744215d8536c";
  sha256 = "1x3ndivv2ya4chx3dmbnal7aan3kc17p450w2dm0r0mi7zan02mb";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
