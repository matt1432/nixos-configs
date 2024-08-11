pkgs:
pkgs.dockerTools.pullImage {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:71668d20d4208d70919cf8cb3caf3071d41ed4b7d95afe71125ccad8408b040d";
  sha256 = "0704a5hanxmssv9cq70n9hj74y0h8rbbr464z4b1k6f5kzxmc3vl";
  finalImageName = "quay.io/vaultwarden/server";
  finalImageTag = "latest";
}
