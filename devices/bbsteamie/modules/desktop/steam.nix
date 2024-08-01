defaultSession: {
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (config.vars) mainUser;

  cfg = config.programs.steam;
in {
  # Normal Steam Stuff
  programs.steam = {
    enable = true;
    protontricks.enable = true;

    remotePlay.openFirewall = true;
    extraCompatPackages = [
      self.packages.${pkgs.system}.proton-ge-latest
    ];
  };

  # Jovian Steam settings
  jovian.steam = {
    # Steam > Settings > System > Enable Developer Mode
    # Steam > Developer > CEF Remote Debugging
    enable = true;
    user = mainUser;

    environment = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        lib.makeSearchPathOutput
        "steamcompattool"
        ""
        cfg.extraCompatPackages;
    };

    desktopSession = defaultSession;
  };

  # Decky settings
  jovian.decky-loader = {
    enable = true;
    user = mainUser;
    stateDir = "/home/${mainUser}/.local/share/decky"; # Keep scoped to user
    # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/1171169117f63f1de9ef2ea36efd8dcf377c6d5a/modules/decky-loader.nix#L80-L84

    extraPackages = with pkgs; [
      # Generic packages
      curl
      unzip
      util-linux
      gnugrep

      readline.out
      procps
      pciutils
      libpulseaudio
    ];
  };

  # Takes way too long to shutdown
  systemd.services."decky-loader".serviceConfig.TimeoutStopSec = "5";

  # Misc Packages
  environment.systemPackages = [
    pkgs.steam-rom-manager
    self.packages.${pkgs.system}.protonhax

    # FIXME:Ryujinx ACNH crashes on OpenGL AND Vulkan
    # https://github.com/Ryujinx/Ryujinx/issues/6993
    # https://github.com/Ryujinx/Ryujinx/issues/6708
    self.packages.${pkgs.system}.yuzu
  ];
}
