pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:fd0411ca373739a6513d82887ab44915f5732adbc5c21dfa1e01d4f4779f7e09";
  sha256 = "0jimix4rq7ic56b1dy61jlv3k7wmc25pjdgv7blhjg81zis21ylc";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7.0.4";
}
