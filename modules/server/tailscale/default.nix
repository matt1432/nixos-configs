{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.networking) hostName;

  cfg = config.roles.server;
in {
  config = mkIf (cfg.enable && cfg.tailscale.enable) {
    services = {
      tailscale = {
        enable = true;

        extraSetFlags = [
          "--operator=${cfg.user}"
        ];
      };
    };

    home-manager.users.${cfg.user} = {
      programs.bash.shellAliases = {
        # Connect to headscale
        tup = "tailscale up --login-server https://headscale.nelim.org";

        # Desktop
        pc = "ssh -t matt@binto 'tmux -2u new -At ${hostName}'";

        # NAS
        nos = "ssh -t matt@nos 'tmux -2u new -At ${hostName}'";

        # Experimenting server
        servivi = "ssh -t matt@servivi 'tmux -2u new -At ${hostName}'";

        # Home-assistant
        homie = "ssh -t matt@homie 'tmux -2u new -At ${hostName}'";

        # Cluster nodes
        thingone = "ssh -t matt@thingone 'tmux -2u new -At ${hostName}'";
        thingtwo = "ssh -t matt@thingtwo 'tmux -2u new -At ${hostName}'";
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
