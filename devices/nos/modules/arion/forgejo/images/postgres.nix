pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:5880b73b30d8e47b11e94e35aed002219e8e301f581e33feb9f062e332046079";
  sha256 = "10ld7pda7svs35939lmch0shc1rjdmrsksiv247656m67yyp1g3j";
  finalImageName = "postgres";
  finalImageTag = "14";
}
