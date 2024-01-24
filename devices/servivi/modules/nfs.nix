# TODO: move this to NAS?

{...}: {
  services.nfs.server = {
    enable = true;
    createMountPoints = true;

    exports = ''
      /export             10.0.0.244(rw,crossmnt,fsid=0,no_root_squash) 10.0.0.159(rw,crossmnt,fsid=0,no_root_squash) 100.64.0.8(rw,crossmnt,fsid=0,no_root_squash) 100.64.0.9(rw,crossmnt,fsid=0,no_root_squash)
      /export/caddy       10.0.0.244(rw,nohide,no_root_squash) 10.0.0.159(rw,nohide,no_root_squash) 100.64.0.8(rw,nohide,no_root_squash) 100.64.0.9(rw,nohide,no_root_squash)
      /export/headscale   10.0.0.244(rw,nohide,no_root_squash) 10.0.0.159(rw,nohide,no_root_squash) 100.64.0.8(rw,nohide,no_root_squash) 100.64.0.9(rw,nohide,no_root_squash)
    '';
  };
}
