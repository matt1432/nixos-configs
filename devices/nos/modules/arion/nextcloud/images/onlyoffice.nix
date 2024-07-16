pkgs:
pkgs.dockerTools.pullImage {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:9b74cb0e05580bced87f9af69de68d5f4c9e5b3340448ddc94333f5f7f4eba85";
  sha256 = "16ybxll9rjab60zkz7p0j1dla1qvqh2j5n7nakcr42gsncyygw46";
  finalImageName = "onlyoffice/documentserver";
  finalImageTag = "latest";
}
