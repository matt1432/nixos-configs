pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:78b9deeca08fa9749a00e9d30bc879f8f8d021af854c73e2c339b752cb6d708a";
  sha256 = "0lr0m8a67zfz50nvb2vbcq3vh0n5r16vvgagjhx8ss644w6x40fm";
  finalImageName = imageName;
  finalImageTag = "14";
}
