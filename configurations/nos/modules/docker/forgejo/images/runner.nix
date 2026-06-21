pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:268ad0d1d24bd7ecf2386b7c44e8211398dc014ca81d4fd5fbad96fe79af18f5";
  hash = "sha256-VwKZvMfDhnZuJ4xJgYk7eaPdeFcNe8c+jOgvaqWBPUo=";
  finalImageName = imageName;
  finalImageTag = "12";
}
