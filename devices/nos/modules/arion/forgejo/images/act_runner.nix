pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:6174ff04dac97969189e205b3dc687d42d798f634b4c204e8763bcd7c8e72cff";
  sha256 = "0r1qwmrmiim9s1dygz3vrb87y3jb2awvwgngckxa2xpa9l5h8pjx";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
