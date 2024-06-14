pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:0bb498026da9fee4c7c703a9ed682aa2aee825a82946c6944a872cbedb44a272";
  sha256 = "1ahpz4a1pdbg7554ydqzfagra32snd6pc7dv1afq5pwyd03cllr4";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.1-fpm";
}
