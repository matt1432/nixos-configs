pkgs: let
  inherit (import ../version.nix) majorVersion version;
in
  pkgs.dockerTools.pullImage rec {
    imageName = "netdaemon/netdaemon${majorVersion}";
    imageDigest = "sha256:4b3750d76c12c84c82f723f31a92e37d4b75d007742ecf2a7226b51fd077f406";
    hash = "sha256-UZ/Ao11/XhVEb8Mfd0LOL0nULA+kCJE5XN+oZHfzeZY=";
    finalImageName = imageName;
    finalImageTag = version;
  }
