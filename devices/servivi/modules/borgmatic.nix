{
  config,
  lib,
  pkgs,
  ...
}: {
  # Make this file declare default settings
  options.services.borgmatic = with lib; {
    defaults = mkOption {
      type = types.attrs;
    };
  };

  # Make sure known_hosts has the needed info
  config = {
    services.borgmatic = {
      enable = true;

      defaults = {
        keep_daily = 7;

        # FIXME: doesn't work, have to put it in /root/.ssh
        ssh_command = "ssh -i /root/.ssh/borg";
        encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borg-repo.path}";

        source_directories_must_exist = true;
        borgmatic_source_directory = "/tmp/borgmatic";
        store_config_files = false;
      };
    };
  };
}
