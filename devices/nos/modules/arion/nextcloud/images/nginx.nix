pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:b72dad1d013c5e4c4fb817f884aa163287bf147482562f12c56368ca1c2a3705";
  sha256 = "1rhan1bq56xkgkfbf41lwsyb99zr0p8l92vrcapnadsaxymhllf3";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
