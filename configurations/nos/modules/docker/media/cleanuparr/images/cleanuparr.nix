pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:1898c3219e7e7ecaf9fcb8474691b6d67d56d0798b01b85690975bae14df11b5";
  hash = "sha256-gkQnCtDpcU2rwIJ/QF4fgYajPA5Vm+c73SZtCf5/LaA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
