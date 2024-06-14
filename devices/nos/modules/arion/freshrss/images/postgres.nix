pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:92e5719074c63b2d30bc8eff29c7f18785a5a5cef01a87dc9e725080747fc57b";
  sha256 = "10ld7pda7svs35939lmch0shc1rjdmrsksiv247656m67yyp1g3j";
  finalImageName = "postgres";
  finalImageTag = "14";
}
