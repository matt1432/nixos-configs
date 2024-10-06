pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:b9e3c35eab182d3de822a53b109b0f27070f6eacea3b1388b9c50d1182f638f2";
  sha256 = "1r59f8b1f8aaps7ghnlb4k9h29rbzr1mlpm1sy4gb7cqyz0i7l8y";
  finalImageName = imageName;
  finalImageTag = "latest";
}
