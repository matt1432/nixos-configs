# Locked
{
  pkgs,
  jmusicbot,
}:
pkgs.dockerTools.buildLayeredImage {
  name = "jmusicbot-docker";
  tag = jmusicbot.version;
  config = {
    created = "now";
    Cmd = ["${jmusicbot}/bin/JMusicBot"];
    WorkingDir = "/jmb/config";
    Volumes."/jmb/config" = {};
  };
}
