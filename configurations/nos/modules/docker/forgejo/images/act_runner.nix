pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:450cb452c6285b107179c273c657658b23b19cc3c71abf4499cc5368827c1cc0";
  hash = "sha256-HtNMCNaz6/JCR6pq6JPgn+7jcLMUCDG42qcVIwXGqLA=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
