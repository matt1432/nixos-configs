pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:10c4e470397dffb67322e7c66b679c9ebf618858b0f435f1095ff035a2881fe6";
  hash = "sha256-FwchGPgbyHbvxFbA6+edhRLclWLwxcR/xhFnURklXro=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
