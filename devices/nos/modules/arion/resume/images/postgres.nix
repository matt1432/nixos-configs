pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:72b0091097472ae5c36ab51d646bc57fa1fc7b01bdf58686411a326a84a4ae78";
  sha256 = "1jqwpc0i75ra1wcw4gcbpiahyql7gjgdhz46pjps3mcgdw6dk9sg";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
