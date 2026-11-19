{
  claude-desktop,
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkForce;

  dotnet-combined = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0-bin
      sdk_10_0-bin
    ];
in {
  # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      libffi
      glibc
    ];
  };

  environment = {
    variables = rec {
      DOTNET_ROOT = "${dotnet-combined}/share/dotnet";

      # https://github.com/dotnet/sdk/issues/51693#issuecomment-3584569224
      DOTNET_ROOT_X64 = DOTNET_ROOT;

      TF_VAR_env = "dev";
      TF_VAR_suffix = "-mhurtubise";
      AWS_SDK_LOAD_CONFIG = "1";
      BROWSER = "/home/${mainUser}/.local/bin/firefox";
    };

    localBinInPath = true;

    systemPackages = attrValues {
      inherit
        (pkgs)
        amazon-ecr-credential-helper
        awscli2
        claude-code
        gcc
        gnumake
        jira-cli-go
        openssl
        tfenv
        uv
        xdg-utils
        ;

      inherit dotnet-combined;

      claude-desktop = let
        claude-desktop-fhs = claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-fhs;
      in
        pkgs.symlinkJoin {
          name = "claude-desktop-wslg";
          paths = [claude-desktop-fhs];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            # The Start menu launches this without the login env, so the
            # theme dirs and the cursors from ../wslg are added explicitly.
            wrapProgram "$out/bin/claude-desktop" \
              --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" \
              --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}" \
              --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" (with pkgs; [adw-gtk3 flat-remix-icon-theme adwaita-icon-theme hicolor-icon-theme])}" \
              --set-default GDK_PIXBUF_MODULE_FILE "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
              --prefix XCURSOR_PATH : "${pkgs.adwaita-icon-theme}/share/icons" \
              --run 'export XCURSOR_PATH="$HOME/.local/share/icons''${XCURSOR_PATH:+:$XCURSOR_PATH}"' \
              --set-default XCURSOR_THEME Windows \
              --set-default XCURSOR_SIZE 24 \
              --add-flags "--ozone-platform=wayland --enable-features=WaylandWindowDecorations"
          '';
        };

      # https://github.com/npm/promise-spawn/blob/e19bfab86f4370eb52911032cae8e4d887e6cd1f/lib/index.js#L159
      sensible-browser = pkgs.writeShellApplication {
        name = "sensible-browser";
        text = ''
          exec "$BROWSER" "$@"
        '';
      };
    };
  };

  home-manager.users.${mainUser} = {
    imports = [
      ({
        config,
        lib,
        ...
      }: let
        inherit (config.lib.file) mkOutOfStoreSymlink;
      in {
        home.sessionPath = ["$HOME/.dotnet/tools"];

        programs.bash.bashrcExtra = ''
          source ~/.landr.sh
        '';

        programs.gh = {
          enable = true;
          extensions = [pkgs.gh-stack];
          gitCredentialHelper.enable = false;
          settings = {
            git_protocol = "https";
            aliases.co = "pr checkout";
          };
        };

        home.file.".local/bin/firefox".source = mkOutOfStoreSymlink "/mnt/c/Program Files/Firefox Developer Edition/firefox.exe";

        # Support claude:// links from Windows
        home.activation.claudeUrlHandler = let
          regFile = pkgs.writeText "claude-url-handler.reg" ''
            REGEDIT4

            [HKEY_CURRENT_USER\Software\Classes\claude]
            @="URL:claude"
            "URL Protocol"=""

            [HKEY_CURRENT_USER\Software\Classes\claude\shell\open\command]
            @="\"C:\\Program Files\\WSL\\wslg.exe\" -d NixOS --cd \"~\" -- /run/current-system/sw/bin/claude-desktop \"%1\""
          '';
          reg = "/mnt/c/Windows/System32/reg.exe";
        in
          lib.hm.dag.entryAfter ["writeBoundary"] ''
            if [ -x ${reg} ]; then
              run ${reg} import "$(/bin/wslpath -w ${regFile})"
            fi
          '';

        home.file.".docker/config.json".text = mkForce ''
          {
            "psFormat": "table {{.ID}}\\t{{.Image}}\\t{{.Names}}\\t{{.Status}}",
            "credHelpers":{"714500182046.dkr.ecr.us-east-1.amazonaws.com":"ecr-login"}
          }
        '';
      })
    ];
  };
}
