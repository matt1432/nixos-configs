pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:9ff236ed47fe39cf1f0acf349d0e5137f8b8a6fd0b46e5117a401010e56222e1";
  sha256 = "1rhan1bq56xkgkfbf41lwsyb99zr0p8l92vrcapnadsaxymhllf3";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
