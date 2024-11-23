pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5d4b2f57adc7739452b0be6cee25f263bfc64b609446bcdd8170354cf8ba8e80";
  sha256 = "0r6yhvby56mqxak91kcp82qix7vagpr5panrzfvn1z6qcb1fcshm";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
