defaultSession: {
  config,
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) attrValues makeSearchPathOutput;
in {
  config = {
    # Normal Steam Stuff
    programs.steam = {
      enable = true;
      protontricks.enable = true;

      remotePlay.openFirewall = true;
      extraCompatPackages = [
        pkgs.selfPackages.proton-ge-latest
      ];

      # https://github.com/NixOS/nixpkgs/issues/25444#issuecomment-1977416787
      extraPackages = with pkgs; [
        kdePackages.breeze
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
          makeSearchPathOutput
          "steamcompattool"
          ""
          config.programs.steam.extraCompatPackages;
      };

      desktopSession = defaultSession;
    };

    # Decky settings
    jovian.decky-loader = {
      enable = true;
      user = mainUser;
      stateDir = "/home/${mainUser}/.local/share/decky"; # Keep scoped to user
      # https://github.com/Jovian-Experiments/Jovian-NixOS/blob/1171169117f63f1de9ef2ea36efd8dcf377c6d5a/modules/decky-loader.nix#L80-L84

      extraPackages = attrValues {
        inherit
          (pkgs)
          curl
          unzip
          util-linux
          gnugrep
          readline
          procps
          pciutils
          libpulseaudio
          ;
      };

      extraPythonPackages = p:
        with p; [
          click
        ];
    };

    # Misc Packages
    environment.systemPackages = [
      pkgs.steam-rom-manager
      pkgs.r2modman

      pkgs.selfPackages.protonhax

      # Ryujinx ACNH crashes on Vulkan
      pkgs.ryujinx
    ];
  };

  # For accurate stack trace
  _file = ./steam.nix;
}
