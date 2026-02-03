homeDirectory: let
  db.system = "/Library/Application Support/com.apple.TCC/TCC.db";
  db.user = "${homeDirectory}${db.system}";
in
  # /System/Library/PreferencePanes/Security.prefPane/Contents/Resources/PrivacyTCCServices.plist
  {
    Accessibility = {
      prefpane = "Privacy_Accessibility";
      database = db.system;
    };
    SystemPolicyAppBundles = {
      prefpane = "Privacy_AppBundles";
      database = db.user;
    };
    BluetoothAlways = {
      prefpane = "Privacy_Bluetooth";
      database = db.user;
    };
    DeveloperTool = {
      prefpane = "Privacy_DevTools";
      database = db.system;
    };
    SystemPolicyAllFiles = {
      prefpane = "Privacy_AllFiles";
      database = db.system;
    };
    ListenEvent = {
      prefpane = "Privacy_ListenEvent";
      database = db.system;
    };
    MediaLibrary = {
      prefpane = "Privacy_Media";
      database = db.user;
    };
    ScreenCapture = {
      prefpane = "Privacy_ScreenCapture";
      database = db.system;
    };
    AudioCapture = {
      prefpane = "Privacy_ScreenCapture";
      database = db.user;
    };
  }
