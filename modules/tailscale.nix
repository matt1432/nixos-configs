{config, ...}: let
  inherit (config.vars) hostName mainUser;
in {
  services = {
    tailscale = {
      enable = true;
      # TODO: add authKeyFile to get extraUpFlags to work
      # https://github.com/juanfont/headscale/issues/1550
      # https://github.com/juanfont/headscale/blob/main/docs/running-headscale-linux-manual.md#register-machine-using-a-pre-authenticated-key
      # https://www.reddit.com/r/NixOS/comments/18kz1nb/tailscale_extraupflags_not_working/
      extraUpFlags = [
        "--login-server https://headscale.nelim.org"
        "--operator=matt"
      ];
    };
  };

  home-manager.users.${mainUser} = {
    programs.bash.shellAliases = {
      # Connect to headscale
      tup = "tailscale up --login-server https://headscale.nelim.org";

      # Desktop
      pc = "ssh -t matt@binto 'tmux -2u new -At ${hostName}'";

      # NAS
      nos = "ssh -t matt@nos 'tmux -2u new -At ${hostName}'";

      # Experimenting server
      servivi = "ssh -t matt@servivi 'tmux -2u new -At ${hostName}'";

      # Cluster nodes
      thingone = "ssh -t matt@thingone 'tmux -2u new -At ${hostName}'";
      thingtwo = "ssh -t matt@thingtwo 'tmux -2u new -At ${hostName}'";
    };
  };
}
