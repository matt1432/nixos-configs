pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:2e890aca16f546bbf8bf20467260855c0a76806177603bd3ae45650c3ceec71c";
  hash = "sha256-Bu6MmZkkifHZx6EoJCeiShs84VCnPpPZY8Cln9Oqunk=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
