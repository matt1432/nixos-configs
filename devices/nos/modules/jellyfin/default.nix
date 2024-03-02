{
  config,
  lib,
  ...
}: let
  inherit (lib) hasAttr fileContents optionals;
  inherit (config.vars) mainUser;

  optionalGroup = name:
    optionals
    (hasAttr name config.users.groups)
    [config.users.groups.${name}.name];
in {
  imports = [
    ./jfa-go.nix
    ./packages.nix
  ];

  users.users."jellyfin".extraGroups =
    optionalGroup mainUser
    ++ optionalGroup "input"
    ++ optionalGroup "media"
    ++ optionalGroup "render";

  services = {
    jellyfin.enable = true;

    nginx = {
      enable = true;
      config = fileContents ./nginx.conf;
    };
  };
}
