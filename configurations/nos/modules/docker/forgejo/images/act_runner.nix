pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:051f944117c5f2453349c4c181601585f6d4a627b1cedcea1b28b3b4821f50a9";
  hash = "sha256-dmkcAAhE9HN4Anx8wX8tLs3nbpyadDhqWN5+s9AtGAY=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
