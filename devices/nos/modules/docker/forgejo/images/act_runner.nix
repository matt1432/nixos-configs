pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:2b5770e40542c158aabba3a1f600d11fd5a0ffe3ff592fcfcf91be617e7c00f8";
  sha256 = "1wjchhrxnh5q9mpvdkjzm3ngrdq93634xvg1jm1rzsi5vycpbzgj";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
