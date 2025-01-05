{
  mkShell,
  writeShellApplication,
  # deps
  findutils,
  gnused,
  nix-output-monitor,
  ...
}:
mkShell {
  packages = [
    (writeShellApplication {
      name = "mkIso";

      runtimeInputs = [
        nix-output-monitor
      ];

      text = ''
        isoConfig="nixosConfigurations.live-image.config.system.build.isoImage"
        nom build "$FLAKE#$isoConfig"
      '';
    })

    (writeShellApplication {
      name = "fixUidChange";

      runtimeInputs = [
        findutils
        gnused
      ];

      text = ''
        GROUP="$1"
        OLD_GID="$2"
        NEW_GID="$3"

        # Remove generated group entry
        sudo sed -i -e "/^$GROUP:/d" /etc/group

        # Change GID on existing files
        sudo find / -gid "$OLD_GID" -exec chgrp "$NEW_GID" {} +
      '';
    })
  ];
}
