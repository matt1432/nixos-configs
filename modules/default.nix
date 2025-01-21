self: {
  base = import ./base self;
  base-droid = import ./base/default-droid.nix self;
  borgbackup = import ./borgbackup;
  caddy-plus = import ./caddy-plus self;
  desktop = import ./desktop self;
  docker = import ./docker self.inputs.khepri;
  esphome-plus = import ./esphome-plus;
  ha-plus = import ./ha-plus;
  kmscon = import ./kmscon;
  nvidia = import ./nvidia;
  meta = import ./meta;
  plymouth = import ./plymouth;
  server = import ./server;
  tmux = import ./tmux;
  wyoming-plus = import ./wyoming-plus;
}
