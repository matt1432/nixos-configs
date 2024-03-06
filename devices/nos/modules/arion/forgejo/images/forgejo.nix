pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:12bac0d8cd3a0b479fb8ce69725aabe2630818a8516a4d13c990d17b122269f0";
  sha256 = "0ijbwr3y8gjf7agivr7z9jqm3q8mqj8a75x2chpvq5p3h1ciida9";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.7-0";
}
