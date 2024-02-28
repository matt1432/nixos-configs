pkgs:
pkgs.dockerTools.pullImage {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:c554223f485843553f7b7c9faff1f5c6c6113ce15b0288dd07210e97d8bbbbcc";
  sha256 = "1vjsr0hfq5dfma2dll6jzkir14ii423nlvjjq6gq0mp9s19jidr7";
  finalImageName = "freshrss/freshrss";
  finalImageTag = "latest";
}
