self: {
  adb = import ./adb;
  borgbackup = import ./borgbackup;
  desktop = import ./desktop self;
  docker = import ./docker self.inputs.khepri;
  esphome-plus = import ./esphome-plus;
  ha-plus = import ./ha-plus;
  kmscon = import ./kmscon;
  nvidia = import ./nvidia;
  plymouth = import ./plymouth;
  server = import ./server;
  tmux = import ./tmux;
  wyoming-plus = import ./wyoming-plus;
}
