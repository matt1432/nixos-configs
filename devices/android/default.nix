{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues concatStringsSep;
in {
  imports = [./nix-on-droid.nix];

  environment.variables.FLAKE = "/data/data/com.termux.nix/files/home/.nix";

  terminal.font = "${(pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontMono-Regular.ttf";

  environment.packages = [
    (pkgs.writeShellApplication {
      name = "switch";

      runtimeInputs = attrValues {
        inherit
          (pkgs)
          coreutils
          nix-output-monitor
          nvd
          ;
      };

      text = ''
        oldProfile=$(realpath /nix/var/nix/profiles/per-user/nix-on-droid/profile)

        nix-on-droid ${concatStringsSep " " [
          "switch"
          "--flake ${config.environment.variables.FLAKE}"
          "--builders ssh-ng://matt@100.64.0.7"
          ''"$@"''
          "|&"
          "nom"
        ]} &&

        nvd diff "$oldProfile" "$(realpath /nix/var/nix/profiles/per-user/nix-on-droid/profile)"
      '';
    })
  ];

  environment.etcBackupExtension = ".bak";
  environment.motd = null;
  home-manager.backupFileExtension = "hm-bak";

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # No touchy
  system.stateVersion = "23.05";
}
