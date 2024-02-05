{config, ...}: let
  inherit (config.vars) mainUser;
in {
  programs = {
    dconf.enable = true;
  };

  home-manager.users.${mainUser} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };

      "apps/seahorse/listing" = {
        keyrings-selected = ["gnupg://"];
      };

      "org/gtk/settings/file-chooser" = {
        show-hidden = true;
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
