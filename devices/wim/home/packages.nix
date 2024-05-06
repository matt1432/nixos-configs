{pkgs, ...}: {
  home.packages =
    (with pkgs.python311Packages; [
      python
      pyclip # For Waydroid?
    ])
    ++ (with pkgs; [
      # Misc CLI
      acpi

      (writeShellScriptBin "Gparted" ''
        (
          sleep 1.5
          while killall -r -0 ksshaskpass > /dev/null 2>&1
          do
            sleep 0.1
            if [[ $(hyprctl activewindow | grep Ksshaskpass) == "" ]]; then
                killall -r ksshaskpass
            fi
          done
        ) &
        exec env SUDO_ASKPASS=${plasma5Packages.ksshaskpass}/bin/${plasma5Packages.ksshaskpass.pname} sudo -k -EA "${gparted}/bin/${gparted.pname}" "$@"
      '')
    ]);

  xdg.desktopEntries.gparted = {
    name = "GParted";
    genericName = "Partition Editor";
    comment = "Create, reorganize, and delete partitions";
    exec = "Gparted";
    icon = "gparted";
    terminal = false;
    type = "Application";
    categories = ["GNOME" "System" "Filesystem"];
    startupNotify = true;
    settings = {
      Keywords = "Partition";
      X-GNOME-FullName = "GParted Partition Editor";
    };
  };
}
