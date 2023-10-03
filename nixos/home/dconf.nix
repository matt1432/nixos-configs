{ ... }:

{
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    "apps/seahorse/listing" = {
      keyrings-selected = [ "gnupg://" ];
    };

    "org/gtk/settings/file-chooser" = {
      show-hidden = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Dracula";
      icon-theme = "Flat-Remix-Violet-Dark";
    };
  };
}
