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

  # Show greeter on all monitors
  dupeMonitors = pkgs.writeShellApplication {
    name = "dupeMonitors";
    runtimeInputs = [hyprland pkgs.jq];
    text = ''
      main="${cfg.mainMonitor}"
      mapfile -t names < <(hyprctl -j monitors | jq -r '.[] .name')

      if [[ "$main" == "null" ]]; then
          main="''${names[0]}"
      fi

      for (( i=0; i<''${#names[@]}; i++ )); do
          name="''${names[$i]}"
          desc=$(hyprctl -j monitors | jq -r '.[] | select(.name == "'"''${names[$i]}"'") | .description')

          if [[ "$name" != "$main" && "desc:$desc" != "$main" ]]; then
                hyprctl eval 'hl.monitor({output="'"$name"'",mode="preferred",position="auto",scale=1,mirror="'"$main"'"})'
          fi
      done

      hyprctl dispatch 'hl.dsp.focus({ monitor = "'"$main"'"})'
    '';
  };
  # Check if user wants the greeter only on main monitor
in {
  setupMonitors =
    if (cfg.mainMonitor != "null" && !cfg.displayManager.duplicateScreen)
    then "hyprctl dispatch 'hl.dsp.focus({ monitor = \\\"${cfg.mainMonitor}\\\" })'"
    else getExe dupeMonitors;
}
