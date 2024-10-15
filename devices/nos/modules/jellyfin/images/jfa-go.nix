pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:5254d210cbd45e7423e7f2ae31e5e6dcfa232311ee79da8edd3b7982b144c598";
  sha256 = "17nwfa9jb2adrx4krvalinsggizwwkn5aq2dmrpr204zq1rhcylb";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
