{config, ...}: let
  inherit (config.vars) hostName mainUser;
in {
  services = {
    tailscale = {
      enable = true;
      # TODO: add authKeyFile to get extraUpFlags to work
      extraUpFlags = [
        "--login-server https://headscale.nelim.org"
        "--operator=matt"
      ];
    };
  };

  home-manager.users.${mainUser} = {
    programs.bash.shellAliases = {
      tup = "tailscale up --login-server https://headscale.nelim.org";

      pc = "ssh -t matt@binto 'tmux -2u new -At ${hostName}'";
      oksys = "ssh -t matt@oksys 'tmux -2u new -At ${hostName}'";
      servivi = "ssh -t matt@servivi 'tmux -2u new -At ${hostName}'";
      pve = "ssh -t matt@pve 'tmux -2u new -At ${hostName}'";

      pod = "mosh matt@pve -- ssh -t -p 6768 matt@10.0.0.122 'tmux -2u new -At ${hostName}'";
      jelly = "mosh matt@pve -- ssh -t matt@10.0.0.123 'tmux -2u new -At ${hostName}'";
      qbit = "mosh matt@pve -- ssh -t matt@10.0.0.128 'tmux -2u new -At ${hostName}'";
    };
  };
}
