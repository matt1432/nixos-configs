pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c9fcaef49a1ca7deae24437c705bf7485922f8a768a140006c5d8abb3f6cac7b";
  sha256 = "0mv71as2k3889idc0m451wr5av0v30f7rb5rrrzgdvy174w39vq6";
  finalImageName = imageName;
  finalImageTag = "14";
}
