{config, ...}: let
  inherit (config.vars) mainUser;
in {
  programs.adb.enable = true;
  users.users.${mainUser}.extraGroups = ["adbusers"];
}
