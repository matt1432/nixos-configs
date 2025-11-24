pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:cfb37eb8d434eb55ba5682eadebfbb42511a85736df34d4f65802c031aadaa28";
  hash = "sha256-5L2q4uHCdDcBYe5r+WQLrWiSEshWE69rRtOmCQJ5bZg=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
