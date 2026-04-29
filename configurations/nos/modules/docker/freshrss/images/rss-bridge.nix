pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:dbd913dba39af6cd36aad1445947aefce706a6aadf63b237e7388e9435ebf626";
  hash = "sha256-9mCRNqFTzWn/3zH6m8SHtZYGDxQH+TK6VfDhFGz7k5U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
