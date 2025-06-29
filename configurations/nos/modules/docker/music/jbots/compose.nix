{configPath, ...}: {
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
  inherit (pkgs.selfPackages) jmusicbot;

  rwPath = configPath + "/music/jbots";
in {
  # TODO: make module to clean this up
  systemd.services = {
    jbot-be = {
      description = "JMusicBot-Be";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = "matt";
        Group = "matt";
        WorkingDirectory = "${rwPath}/be";
        ExecStart = getExe jmusicbot;
        Restart = "always";
      };
    };

    jbot-br = {
      description = "JMusicBot-Br";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = "matt";
        Group = "matt";
        WorkingDirectory = "${rwPath}/br";
        ExecStart = getExe jmusicbot;
        Restart = "always";
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
