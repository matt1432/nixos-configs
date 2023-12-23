{config, ...}: {
  services = {
    tailscale = {
      enable = true;
      extraUpFlags = [
        "--login-server https://headscale.nelim.org"
        "--operator=matt"
      ];
    };
  };

  home-manager.users.${config.vars.user}.programs.bash.shellAliases = {
    tup = "tailscale up --login-server https://headscale.nelim.org";

    pc = "mosh matt@binto -- tmux -2u new -At ${config.vars.hostName}";
    oksys = "mosh matt@oksys -- tmux -2u new -At ${config.vars.hostName}";
    servivi = "mosh matt@servivi -- tmux -2u new -At ${config.vars.hostName}";
    pve = "mosh matt@pve -- tmux -2u new -At ${config.vars.hostName}";

    mc = "mosh mc@mc -- tmux -2u new -At ${config.vars.hostName}";
    pod = "mosh matt@pve -- ssh -t -p 6768 matt@10.0.0.122 'tmux -2u new -At ${config.vars.hostName}'";
    jelly = "mosh matt@pve -- ssh -t matt@10.0.0.123 'tmux -2u new -At ${config.vars.hostName}'";
    qbit = "mosh matt@pve -- ssh -t matt@10.0.0.128 'tmux -2u new -At ${config.vars.hostName}'";
  };
}
