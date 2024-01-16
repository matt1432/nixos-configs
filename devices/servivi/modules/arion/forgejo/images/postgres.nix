pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:ee0c3153cf67af84ac2a8d974cd5b01a6497b35209c175d8f94f7b8ad276d844";
  sha256 = "11si5135mmmd9mqs886xpcqw3z4iilxk44y2nmv8yj5irxgfhcyl";
  finalImageName = "postgres";
  finalImageTag = "14";
}
