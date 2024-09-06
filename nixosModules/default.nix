self: {
  adb = import ./adb;
  borgbackup = import ./borgbackup;
  desktop = import ./desktop self;
  docker = import ./docker self.inputs.khepri;
  esphome-plus = import ./esphome-plus;
  kmscon = import ./kmscon;
  nvidia = import ./nvidia;
  plymouth = import ./plymouth;
  server = import ./server;
  wyoming-plus = import ./wyoming-plus;
}
