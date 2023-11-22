{
  pkgs,
  lib,
  ...
}: {
  services.fprintd.enable = true;

  # https://www.reddit.com/r/NixOS/comments/z7i83r/fingertip_tip_start_fprintd_at_boot_for_a_quick/
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };

  services.logind.lidSwitch = "lock";

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=600
  '';

  security.pam.services = {
    gtklock = {};

    # all the changes in /etc/pam.d/*
    sddm.text = lib.mkBefore ''
      auth      [success=1 new_authtok_reqd=1 default=ignore]  	pam_unix.so try_first_pass likeauth nullok
      auth      sufficient    ${pkgs.fprintd}/lib/security/pam_fprintd.so
    '';

    sudo.text = ''
      # Account management.
      auth    sufficient    ${pkgs.pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so
      auth    sufficient    pam_unix.so try_first_pass nullok
      account required pam_unix.so

      # Authentication management.
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok yescrypt

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';

    login.text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth    sufficient    ${pkgs.pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so
      auth optional pam_unix.so nullok  likeauth
      auth optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
      auth    sufficient    pam_unix.so try_first_pass nullok
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok yescrypt
      password optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so use_authtok

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
      session required pam_loginuid.so
      session required ${pkgs.pam}/lib/security/pam_lastlog.so silent
      session optional ${pkgs.systemd}/lib/security/pam_systemd.so
      session optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';

    polkit-1.text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth    sufficient    ${pkgs.pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so
      auth    sufficient    pam_unix.so try_first_pass nullok
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok yescrypt

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';
  };
}
