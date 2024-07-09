{
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) mkDefault mkBefore;
  inherit (self.packages.${pkgs.system}) pam-fprint-grosshack;

  pam_fprintd_grosshackSo = "${pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so";

  # https://wiki.archlinux.org/title/Fprint#Login_configuration
  grosshackConf = ''
    # pam-fprint-grosshack
    auth  sufficient  ${pam_fprintd_grosshackSo} timeout=99
    auth  sufficient  pam_unix.so try_first_pass nullok
  '';
in {
  services.fprintd = {
    enable = true;

    # FIXME: https://github.com/NixOS/nixpkgs/issues/325836
    package = pkgs.fprintd.overrideAttrs (o: rec {
      version = "1.94.3";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "libfprint";
        repo = "fprintd";
        rev = "v${version}";
        sha256 = "sha256-shH+ctQAx4fpTMWTmo3wB45ZS38Jf8RknryPabfZ6QE=";
      };
      patches = [];
      mesonCheckFlags = [
        "--no-suite"
        "fprintd:PAM"
        "--no-suite"
        "fprintd:TestPamFprintd"
      ];
    });
  };

  # https://www.reddit.com/r/NixOS/comments/z7i83r/fingertip_tip_start_fprintd_at_boot_for_a_quick/
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  services.logind.lidSwitch = "lock";

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=600
  '';

  # https://stackoverflow.com/a/47041843
  security.pam.services = {
    sudo.text = mkDefault (mkBefore grosshackConf);
    login.text = mkDefault (mkBefore grosshackConf);
    polkit-1.text = mkDefault (mkBefore grosshackConf);
    ags.text = mkDefault (mkBefore grosshackConf);
  };
}
