pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:e1b1f2503f382fa98951596e3b9ac856efcd993bc9b888d6780ef25c0995b002";
  sha256 = "1vss6784rvg6vrwk1mdb7zqmwf0l6ng6gpz9h6z7xyp7m9979w2b";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
