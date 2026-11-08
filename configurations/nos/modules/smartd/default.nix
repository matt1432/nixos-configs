{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  ntfyNotify = pkgs.writeShellScript "smartd-ntfy" ''
    ${getExe pkgs.curl} -fsS \
      -H "Title: ${config.networking.hostName}: $SMARTD_FAILTYPE on $SMARTD_DEVICE" \
      -H "Priority: urgent" \
      -H "Tags: warning,floppy_disk" \
      -d "$SMARTD_FULLMESSAGE" \
      https://ntfy.nelim.org/nos-alerts
  '';
in {
  services.smartd = {
    enable = true;
    autodetect = true;

    notifications.wall.enable = false;

    # -a: monitor everything, -o on: automatic offline testing
    # -s: short self-test daily at 02:00, long self-test Saturdays at 03:00
    # -M exec: send warnings to ntfy instead of mail
    defaults.autodetected = "-a -o on -s (S/../.././02|L/../../6/03) -m <nomailer> -M exec ${ntfyNotify}";
  };
}
