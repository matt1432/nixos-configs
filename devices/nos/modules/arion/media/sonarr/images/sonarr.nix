pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sonarr";
  imageDigest = "sha256:24b7f3f1c9ed065adc3ca7c5440944560b010a38e9bfcb7c1d8e9c965cbc8ea8";
  sha256 = "176561m2l1i7hkzibprm2d6l0l9ckw36zm7r49r099xxnp3fhx9f";
  finalImageName = "lscr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
