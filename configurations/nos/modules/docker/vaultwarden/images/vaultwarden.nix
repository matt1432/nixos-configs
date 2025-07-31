pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:84fd8a47f58d79a1ad824c27be0a9492750c0fa5216b35c749863093bfa3c3d7";
  hash = "sha256-a41Hd5hgpGZHcyp95FUCy7nNRgImtqDcwcBO533G6SA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
