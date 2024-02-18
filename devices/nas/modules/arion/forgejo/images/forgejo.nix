pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:07da5c53136cb00a097bfb145653f2df96b06ed945542f08fa09d342ead42921";
  sha256 = "00jxig1y3bfbha6jlzkijy811pn2das6kkg1lw132pxskf8dw2sy";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.5-0";
}
