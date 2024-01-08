pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:5c89548057b137f5e2a78ed3434848679cb1fc5a510a4042caf7b47115c5174e";
  sha256 = "13icchd25fwrdwsjg30g5fl0mgj7sndqa4g4pfry5cdprz0j5y9w";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.3-0";
}
