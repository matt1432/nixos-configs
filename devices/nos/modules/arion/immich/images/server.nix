pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:ad7a9828eb25e4f42ad17631bc81408b3fe464c4eec2300742af2e37acb4e8d6";
  sha256 = "0yiyfh70idbyzzy8qdlxqg3vn1wiyn0wx5c8v5vgx3ys65wk2ayd";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.99.0";
}
