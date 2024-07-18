pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:7c3e7840c726828643131583514b66f38e7af29021d5a7b05ed8ed5c8ec0b596";
  sha256 = "18szrqzgg9569q8i89p0i4533zvs2yq8d3y1yyxf9wbam9a9mgl1";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
