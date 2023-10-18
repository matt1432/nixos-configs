{ lib, ... }: {
  options.services.hostvars = with lib; {
    username = mkOption {
      description = ''
        Username that was defined at the initial setup process
      '';
	    type = types.nullOr types.str;
    };

    configDir = mkOption {
      description = ''
        The path to where most of the hosts' configs are in the .nix folder
      '';
      type = types.nullOr types.str;
    };

    fontSize = mkOption {
      type = types.nullOr types.float;
    };
  };
}
