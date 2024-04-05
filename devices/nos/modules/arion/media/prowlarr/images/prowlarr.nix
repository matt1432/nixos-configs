pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:a77b1f5b22fed9fd726e49bfa6800897676a3eee030d5f194d7858cb858aa6d0";
  sha256 = "1dbpm8cxqydm21ybkz8rvqyga4q7hg36w6fh8qdmgb4w4f3mv7pj";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
