{mainUser, ...}: let
  inherit (builtins) toJSON;
in {
  homebrew.casks = ["linearmouse"];

  launchd.user.agents."linearmouse".serviceConfig = {
    ProgramArguments = [
      "/usr/bin/open"
      "/Applications/LinearMouse.app"
    ];
    RunAtLoad = true;
    LimitLoadToSessionType = "Aqua";
  };

  darwin.tccutil = [
    "com.lujjjh.LinearMouse"
  ];

  home-manager.users.${mainUser} = {
    xdg.configFile."linearmouse/linearmouse.json".text = toJSON {
      schemes = [
        {
          "if" = {
            device.category = "trackpad";
          };

          pointer = {
            acceleration = "unset";
            disableAcceleration = true;
            redirectsToScroll = false;
            speed = "unset";
          };

          scrolling.reverse = false;
        }

        {
          "if" = {
            device.category = "mouse";
          };

          pointer.disableAcceleration = true;

          scrolling = {
            reverse.vertical = true;
            speed.vertical = 0;
          };
        }
      ];

      "$schema" = "https://schema.linearmouse.app/0.10.2";
    };
  };
}
