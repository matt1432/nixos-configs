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

        # SSH
        # Desktop
        pc = "ssh -t matt@100.64.0.6 'tmux -2u new -At ${hostName}'";

        # NAS
        nos = "ssh -t matt@100.64.0.4 'tmux -2u new -At ${hostName}'";

        # Build server
        servivi = "ssh -t matt@100.64.0.7 'tmux -2u new -At ${hostName}'";

        # Home-assistant
        homie = "ssh -t matt@100.64.0.10 'tmux -2u new -At ${hostName}'";

        # Cluster nodes
        thingone = "ssh -t matt@100.64.0.8 'tmux -2u new -At ${hostName}'";
        thingtwo = "ssh -t matt@100.64.0.9 'tmux -2u new -At ${hostName}'";
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
