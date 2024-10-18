pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:085092799d1b25370956972185145607246d692da64c18ef55c2da20eecc855d";
  sha256 = "1qqla94dw8jr2rq85316xqs0lbihmlq75kpskdhlx6n9kh2z7x88";
  finalImageName = imageName;
  finalImageTag = "9";
}
