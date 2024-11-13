pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:ee4962ccfb8e99e8541f59130ddfda5b82b5c4c82eba513f2ee03216c2d0dd85";
  sha256 = "0qvwhpmjzsb22bbf1vsvhgmb3rggrfc4vh0dhpl4s9m7iijh3lf0";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
