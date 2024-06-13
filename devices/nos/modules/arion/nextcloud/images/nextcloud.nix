pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:40a5a898dfbb37a907321b37dfe05f36e6f0f693c9bbbbe420af22906e975a74";
  sha256 = "1ahpz4a1pdbg7554ydqzfagra32snd6pc7dv1afq5pwyd03cllr4";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.1-fpm";
}
