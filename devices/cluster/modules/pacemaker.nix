{nixpkgs-pacemaker, ...}: let
  pacemakerPath = "services/cluster/pacemaker/default.nix";
in {
  # FIXME: https://github.com/NixOS/nixpkgs/pull/208298
  nixpkgs.overlays = [
    (final: prev: {
      inherit
        (nixpkgs-pacemaker.legacyPackages.x86_64-linux)
        pacemaker
        ocf-resource-agents
        ;
    })
  ];

  disabledModules = [pacemakerPath];
  imports = ["${nixpkgs-pacemaker}/nixos/modules/${pacemakerPath}"];

  services.pacemaker.enable = true;
}
