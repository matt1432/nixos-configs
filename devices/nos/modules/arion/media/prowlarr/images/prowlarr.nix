pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:9c5d4a00141daab9e331bc998c35e4214db775a617ef2e629f606a5af7e40256";
  sha256 = "1xqxp0njpr3vhds0i5bas5yal5lj9rzls0x42wf05hyq4a5vk3jf";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
