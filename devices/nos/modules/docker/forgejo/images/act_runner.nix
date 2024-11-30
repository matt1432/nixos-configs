pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:dc29037a106628d8020cfb96bd5856dfe5db431ab6a6430455fab2a741249215";
  sha256 = "09vq2cc4cmscvrlym6vmcwgmmzyhgrijydgh48llbak7nsf9szq4";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
