pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:1f7c844e1c723ba09411a31f9a3ef8f551e6d77c9ff4f200ef36b870e8c8a3d7";
  sha256 = "sha256-pD16fE+xr7qq+cndTGiXmOQBuAmEPD/Vvn57mLy3ilU=";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "8";
}
