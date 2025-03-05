pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a1c106a18b1fa02736064a18f9d31d18253347b7625673a58d5cfd98cc64bc2f";
  hash = "sha256-7VImcP/RRncdHzdO8ipyyFxco5e2KCp/+Wyk+gbhwZg=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
