pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:0b50b596246cc4c439b6113411973f4c0639cb8556c7cf98e8017efdb5c3ab90";
  sha256 = "0hw9qmhs5ykry51kc7cl1w1kcswrpza8dsam5b5samcb0ga609ng";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7.0.1";
}
