pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:f78c5b727b6c94942803f6a3bc47aa60fe197b97417d869448aa6e7fd4bba55c";
  sha256 = "0ha6dfpqy083h48akzk8wmc4v9vhjvjv395fwyv5inxzy70y3i5l";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
