{
  config,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser greetdDupe mainMonitor;
  hyprland = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;

  # Show Regreet on all monitors
  dupeMonitors = pkgs.writeShellApplication {
    name = "dupeMonitors";
    runtimeInputs = [hyprland pkgs.jq];
    text = ''
      main="${mainMonitor}"
      names="($(hyprctl -j monitors | jq -r '.[] .description'))"

      if [[ "$main" == "null" ]]; then
          main="''${names[0]}"
      fi

      for (( i=0; i<''${#names[@]}; i++ )); do

          # shellcheck disable=SC2001
          name=$(echo "''${names[$i]}" | sed 's/.*(\(.*\))/\1/')
          # shellcheck disable=SC2001
          desc=$(echo "''${names[$i]}" | sed 's/ (.*//')

          if [[ "$name" != "$main" && "desc:$desc" != "$main" ]]; then
              hyprctl keyword monitor "$name",preferred,auto,1,mirror,"$main"
          fi
      done
    '';
  };
  # Check if user wants the greeter only on main monitor
in {
  setupMonitors =
    if (mainMonitor != "null" && !greetdDupe)
    then "hyprctl dispatch focusmonitor ${mainMonitor}"
    else "${dupeMonitors}/bin/dupeMonitors";
}
