pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/jlesage/jdownloader-2";
  imageDigest = "sha256:3e6719acd53ba595f0c62b078e768ce3a983febaf35c217b569325f95c18fe6b";
  hash = "sha256-0KmgumAalR08i+f1dWlmHosT0WF4DO5LepyQ8TZO5Jg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
