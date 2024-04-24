pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:c3c662609a02cf6d384fa3698c59eceaf78b8799dbfee4ea4e438eb19f613095";
  sha256 = "0zx9ikm66bqdlkfgcj2v7si17qsc1m69xjjxf1ghdnia4wnwbch9";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7";
}
