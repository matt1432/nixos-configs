pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:2b0180b8ca27b36f27e0ddea0e9e8a5b1d40fcf478dc31f7e2efcfb9ce1bf42a";
  sha256 = "1yq92d7wqjwkbhacxjrw85426iyrv59l4rh2cbphbgpavbakzqym";
  finalImageName = imageName;
  finalImageTag = "latest";
}
