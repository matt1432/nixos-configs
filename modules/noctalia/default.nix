self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) noctalia;

  inherit (lib) mkIf;

  # Configs
  cfgDesktop = config.roles.desktop;

  hmCfg = config.home-manager.users.${cfgDesktop.user};
  noctaliaCfg = hmCfg.programs.noctalia-shell;
in {
  config = mkIf cfgDesktop.noctalia.enable {
    services.upower.enable = true;

    roles.desktop.lockPackage = pkgs.writeShellApplication {
      name = "lockPackage";
      runtimeInputs = [noctaliaCfg.package];
      text = ''
        exec noctalia-shell ipc call lockScreen lock
      '';
    };

    home-manager.users.${cfgDesktop.user} = {
      imports = [
        noctalia.homeModules.default
        (import ./hyprland.nix self)
      ];

      programs.noctalia-shell = {
        enable = true;

        package = pkgs.noctalia-shell.overrideAttrs (o: {
          postPatch = ''
            ${o.postPatch or ""}

            # Make layers be shown above fullscreen apps
            ${pkgs.findutils}/bin/find -name "*.qml" -exec sed -i 's/WlrLayer.Top/WlrLayer.Overlay/g' {} \;

            # Make interface scaling affect the bar
            sed -i 's/toOdd(h)/toOdd(h * uiScaleRatio)/g' ./Commons/Style.qml
            sed -i 's/baseFontSize = /baseFontSize = uiScaleRatio * /g' ./Commons/Style.qml

            # Make workspace pills circles
            sed -i 's/    radius: Style.radiusM/    radius: 16/g' ./Modules/Bar/Extras/WorkspacePill.qml
          '';
        });

        settings = {
          settingsVersion = 46;

          general = {
            allowPanelsOnScreenWithoutBar = true;
            allowPasswordWithFprintd = true;
            animationDisabled = false;
            animationSpeed = 1;
            autoStartAuth = true;
            avatarImage = "";
            boxRadiusRatio = 1;
            compactLockScreen = true;
            dimmerOpacity = 0;
            enableLockScreenCountdown = true;
            enableShadows = true;
            forceBlackScreenCorners = true;
            iRadiusRatio = 1;
            language = "";
            lockOnSuspend = false;
            lockScreenCountdownDuration = 10000;
            radiusRatio = 0.5;
            scaleRatio = 1.15;
            screenRadiusRatio = 0.5;
            shadowDirection = "center";
            shadowOffsetX = 0;
            shadowOffsetY = 0;
            showChangelogOnStartup = false;
            showHibernateOnLockScreen = false;
            showScreenCorners = true;
            showSessionButtonsOnLockScreen = false;
            telemetryEnabled = false;
          };

          ui = {
            bluetoothDetailsViewMode = "grid";
            bluetoothHideUnnamedDevices = false;
            boxBorderEnabled = false;
            fontDefault = "Noto Nerd Font";
            fontDefaultScale = 1.2;
            fontFixed = "monospace";
            fontFixedScale = 1;
            networkPanelView = "wifi";
            panelBackgroundOpacity = 0.93;
            panelsAttachedToBar = true;
            settingsPanelMode = "attached";
            tooltipsEnabled = true;
            wifiDetailsViewMode = "grid";
          };

          appLauncher = {
            autoPasteClipboard = false;
            clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
            clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
            clipboardWrapText = true;
            customLaunchPrefix = "";
            customLaunchPrefixEnabled = false;
            enableClipPreview = true;
            enableClipboardHistory = true;
            enableSettingsSearch = false;
            enableWindowsSearch = true;
            iconMode = "tabler";
            ignoreMouseInput = false;
            pinnedApps = [
              "firefox-devedition"
              "discord"
              "com.github.xournalpp.xournalpp"
            ];
            position = "follow_bar";
            screenshotAnnotationTool = "satty -f -";
            showCategories = true;
            showIconBackground = false;
            sortByMostUsed = true;
            terminalCommand = "foot -e";
            useApp2Unit = false;
            viewMode = "list";
          };

          audio = {
            volumeStep = 5;
            volumeFeedback = false;
            volumeOverdrive = false;

            visualizerType = "none";
            preferredPlayer = "";
            mprisBlacklist = [];
          };

          bar = {
            autoHideDelay = 500;
            autoShowDelay = 150;
            backgroundOpacity = 0.7;
            barType = "simple";
            capsuleOpacity = 0.6;
            density = "spacious";
            displayMode = "always_visible";
            floating = false;
            frameRadius = 12;
            frameThickness = 8;
            hideOnOverview = false;
            marginHorizontal = 4;
            marginVertical = 4;
            monitors = [];
            outerCorners = true;
            position = "top";
            screenOverrides = [];
            showCapsule = true;
            showOutline = false;
            useSeparateOpacity = false;

            widgets = {
              center = [
                {
                  customFont = "";
                  formatHorizontal = "ddd. d MMM. h:mm AP";
                  formatVertical = "HH mm - dd MM";
                  id = "Clock";
                  tooltipFormat = "HH:mm ddd, MMM dd";
                  useCustomFont = false;
                  usePrimaryColor = false;
                }
              ];

              left = [
                {
                  characterCount = 2;
                  colorizeIcons = false;
                  emptyColor = "tertiary";
                  enableScrollWheel = false;
                  focusedColor = "primary";
                  followFocusedScreen = false;
                  groupedBorderOpacity = 1;
                  hideUnoccupied = false;
                  iconScale = 0.8;
                  id = "Workspace";
                  labelMode = "none";
                  occupiedColor = "secondary";
                  reverseScroll = false;
                  showApplications = false;
                  showBadge = true;
                  showLabelsOnlyWhenOccupied = true;
                  unfocusedIconsOpacity = 1;
                }
                {
                  blacklist = ["*spotify*"];
                  colorizeIcons = false;
                  drawerEnabled = false;
                  hidePassive = false;
                  id = "Tray";
                  pinned = [];
                }
                {
                  colorizeIcons = false;
                  hideMode = "hidden";
                  id = "ActiveWindow";
                  maxWidth = 145;
                  scrollingMode = "hover";
                  showIcon = true;
                  useFixedWidth = false;
                }
              ];

              right = [
                {
                  displayMode = "onhover";
                  id = "Network";
                }
                {
                  displayMode = "onhover";
                  id = "Bluetooth";
                }
                {
                  displayMode = "onhover";
                  id = "KeyboardLayout";
                  showIcon = true;
                }
                {
                  hideWhenZero = false;
                  hideWhenZeroUnread = false;
                  id = "NotificationHistory";
                  showUnreadBadge = true;
                  unreadBadgeColor = "primary";
                }
                {
                  displayMode = "onhover";
                  id = "Volume";
                  middleClickCommand = "pwvucontrol || pavucontrol";
                }
                {
                  displayMode = "onhover";
                  id = "Brightness";
                }
                {
                  deviceNativePath = "__default__";
                  displayMode = "icon-always";
                  hideIfIdle = false;
                  hideIfNotDetected = true;
                  id = "Battery";
                  showNoctaliaPerformance = false;
                  showPowerProfiles = false;
                  warningThreshold = 30;
                }
                {
                  colorizeDistroLogo = false;
                  colorizeSystemIcon = "primary";
                  customIconPath = "";
                  enableColorization = true;
                  icon = "noctalia";
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
              ];
            };
          };

          brightness = {
            brightnessStep = 5;
            enableDdcSupport = false;
            enforceMinimum = true;
          };

          calendar = {
            cards = [
              {
                enabled = true;
                id = "calendar-header-card";
              }
              {
                enabled = true;
                id = "calendar-month-card";
              }
              {
                enabled = false;
                id = "weather-card";
              }
            ];
          };

          colorSchemes = {
            darkMode = true;
            generationMethod = "tonal-spot";
            manualSunrise = "06:30";
            manualSunset = "18:30";
            monitorForColors = "";
            predefinedScheme = "Dracula";
            schedulingMode = "off";
            useWallpaperColors = false;
          };

          controlCenter = {
            cards = [
              {
                enabled = true;
                id = "profile-card";
              }
              {
                enabled = false;
                id = "shortcuts-card";
              }
              {
                enabled = false;
                id = "audio-card";
              }
              {
                enabled = false;
                id = "brightness-card";
              }
              {
                enabled = false;
                id = "weather-card";
              }
              {
                enabled = true;
                id = "media-sysmon-card";
              }
            ];

            diskPath = "/";
            position = "close_to_bar_button";

            shortcuts = {
              left = [
                {id = "Network";}
                {id = "Bluetooth";}
              ];

              right = [
                {id = "Notifications";}
              ];
            };
          };

          hooks = {
            darkModeChange = "";
            enabled = true;
            performanceModeDisabled = "";
            performanceModeEnabled = "";
            screenLock = "";
            screenUnlock = "";
            session = "";
            startup = "";
            wallpaperChange = "";
          };

          location = {
            analogClockInCalendar = false;
            firstDayOfWeek = -1;
            hideWeatherCityName = false;
            hideWeatherTimezone = false;
            name = "Montreal";
            showCalendarEvents = true;
            showCalendarWeather = true;
            showWeekNumberInCalendar = true;
            use12hourFormat = true;
            useFahrenheit = false;
            weatherEnabled = false;
            weatherShowEffects = true;
          };

          network = {
            bluetoothDetailsViewMode = "grid";
            bluetoothHideUnnamedDevices = false;
            bluetoothRssiPollIntervalMs = 10000;
            bluetoothRssiPollingEnabled = false;
            wifiDetailsViewMode = "grid";
            wifiEnabled = true;
          };

          notifications = {
            backgroundOpacity = 1;
            criticalUrgencyDuration = 15;
            enableKeyboardLayoutToast = true;
            enableMediaToast = false;
            enabled = true;
            location = "top_right";
            lowUrgencyDuration = 3;
            monitors = [];
            normalUrgencyDuration = 8;
            overlayLayer = true;
            respectExpireTimeout = false;
            saveToHistory = {
              critical = true;
              low = true;
              normal = true;
            };

            sounds.enabled = false;
          };

          osd = {
            autoHideMs = 2000;
            backgroundOpacity = 1;
            enabled = true;
            enabledTypes = [0 1 2 3];
            location = "bottom";
            monitors = [];
            overlayLayer = true;
          };

          sessionMenu = {
            countdownDuration = 10000;
            enableCountdown = false;
            largeButtonsLayout = "single-row";
            largeButtonsStyle = true;
            position = "center";
            powerOptions = [
              {
                action = "lock";
                command = "";
                countdownEnabled = true;
                enabled = true;
                keybind = "";
              }
              {
                action = "suspend";
                command = "";
                countdownEnabled = true;
                enabled = false;
                keybind = "";
              }
              {
                action = "hibernate";
                command = "";
                countdownEnabled = true;
                enabled = false;
                keybind = "";
              }
              {
                action = "reboot";
                command = "";
                countdownEnabled = true;
                enabled = true;
                keybind = "";
              }
              {
                action = "logout";
                command = "";
                countdownEnabled = true;
                enabled = true;
                keybind = "";
              }
              {
                action = "shutdown";
                command = "";
                countdownEnabled = true;
                enabled = true;
                keybind = "";
              }
            ];
            showHeader = true;
            showNumberLabels = true;
          };

          # Disabled or unused
          desktopWidgets.enabled = false;
          dock.enabled = false;
          nightLight.enabled = false;
          wallpaper.enabled = false;

          templates = {
            activeTemplates = [];
            enableUserTheming = false;
          };

          # TODO: find way to disable this
          systemMonitor = {
            cpuCriticalThreshold = 90;
            cpuPollingInterval = 1000;
            cpuWarningThreshold = 80;
            criticalColor = "";
            diskCriticalThreshold = 90;
            diskPollingInterval = 30000;
            diskWarningThreshold = 80;
            enableDgpuMonitoring = false;
            externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
            gpuCriticalThreshold = 90;
            gpuPollingInterval = 3000;
            gpuWarningThreshold = 80;
            loadAvgPollingInterval = 3000;
            memCriticalThreshold = 90;
            memPollingInterval = 1000;
            memWarningThreshold = 80;
            networkPollingInterval = 1000;
            swapCriticalThreshold = 90;
            swapWarningThreshold = 80;
            tempCriticalThreshold = 90;
            tempPollingInterval = 3000;
            tempWarningThreshold = 80;
            useCustomColors = false;
            warningColor = "";
          };
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
