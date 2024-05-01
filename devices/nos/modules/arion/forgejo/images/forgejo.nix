pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:0b50b596246cc4c439b6113411973f4c0639cb8556c7cf98e8017efdb5c3ab90";
  sha256 = "1jbnmdr7jdbwpmbl5gsp7p3yql1bd83fnmp3k1h6xymw7nigzflk";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7";
}
