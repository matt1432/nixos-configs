pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a6d70b4df97eab6b52ee7094c80109b28c0c2e8d9066c60b71b3222e88726444";
  sha256 = "0z0ffjavp2r07vp61f7ygwps28m0h9hkdvva0gj4bgsbwdk0pn76";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
