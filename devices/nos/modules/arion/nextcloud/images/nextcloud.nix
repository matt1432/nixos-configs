pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:7df7de6e9b7438839f1f7519ae345015bda742754b65d90659d0214bfe07c00b";
  sha256 = "1kg54w12ja78cm33hvj0c21wlmx7mdg7rcwb7r75ig46w175p9v2";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.3-fpm";
}
