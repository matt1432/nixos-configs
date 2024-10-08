defaultSession: {
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  config = let
    inherit (config.vars) mainUser;
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

      extraPackages = builtins.attrValues {
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
    };

    # Misc Packages
    environment.systemPackages = [
      pkgs.steam-rom-manager
      pkgs.r2modman

      self.packages.${pkgs.system}.protonhax

      # Ryujinx ACNH crashes on Vulkan
      pkgs.ryujinx
    ];
  };

  # For accurate stack trace
  _file = ./steam.nix;
}
