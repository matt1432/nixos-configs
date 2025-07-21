pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:9f5454881597f97a15e1cea8c234f87a21aee4ecab273d827debdfc6e78c16b3";
  hash = "sha256-4qWMrZq+wLzHQ0lY4ebh8nY5B8DHcOvunGTHRUfRwXg=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
