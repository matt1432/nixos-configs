{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;

  cfg = config.roles.desktop;

  hyprland =
    config
    .home-manager
    .users
    .${cfg.user}
    .wayland
    .windowManager
    .hyprland
    .finalPackage;

  # Show Regreet on all monitors
  dupeMonitors = pkgs.writeShellApplication {
    name = "dupeMonitors";
    runtimeInputs = [hyprland pkgs.jq];
    text = ''
      main="${cfg.mainMonitor}"
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
              # FIXME: replace this with lua equivalent and check if rest of script works
              hyprctl keyword monitor "$name",preferred,auto,1,mirror,"$main"
          fi
      done

      dispatch='hl.dsp.focus({ monitor = "'
      dispatch+="$main"
      dispatch+='"})'
      hyprctl dispatch "$dispatch"
    '';
  };
  # Check if user wants the greeter only on main monitor
in {
  setupMonitors =
    if (cfg.mainMonitor != "null" && !cfg.displayManager.duplicateScreen)
    then "hyprctl dispatch 'hl.dsp.focus({ monitor = \\\"${cfg.mainMonitor}\\\" })'"
    else getExe dupeMonitors;
}
