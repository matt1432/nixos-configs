pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b2df3a59e11b2548e42ab3fe3f0f8846bf2dff647edf763845b1976cdb3984ba";
  sha256 = "1ckbr0xbi6vi5bmlkdhl1h0x3nc9r3p1a4vbfpf51lygqm5mj8nz";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
