{ config, pkgs, ... }:

{
  services.fprintd.enable = true;

  # https://www.reddit.com/r/NixOS/comments/z7i83r/fingertip_tip_start_fprintd_at_boot_for_a_quick/
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  services.logind.lidSwitch = "lock";
  services.gnome.gnome-keyring.enable = true;
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

  security.pam.services = {
    
    gtklock = {};

    # all the changes in /etc/pam.d/*
    sddm.text = ''
      auth      [success=1 new_authtok_reqd=1 default=ignore]  	pam_unix.so try_first_pass likeauth nullok
      auth      sufficient    /nix/store/7hw6i2p2p7zzgjirw6xaj3c50gga488y-fprintd-1.94.2/lib/security/pam_fprintd.so
      auth      substack      login
      account   include       login
      password  substack      login
      session   include       login
    '';

    sudo.text = ''
      # Account management.
      auth    sufficient    /root/lib/pam/pam_fprintd_grosshack.so
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
      auth    sufficient    /root/lib/pam/pam_fprintd_grosshack.so
      auth optional pam_unix.so nullok  likeauth
      auth optional /nix/store/21dqfghfa8b09ssvgja8l5bg7h5d9rzl-gnome-keyring-42.1/lib/security/pam_gnome_keyring.so
      auth    sufficient    pam_unix.so try_first_pass nullok
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok yescrypt
      password optional /nix/store/21dqfghfa8b09ssvgja8l5bg7h5d9rzl-gnome-keyring-42.1/lib/security/pam_gnome_keyring.so use_authtok

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
      session required pam_loginuid.so
      session required /nix/store/4m8ab1p9y6ig31wniimlvsl23i9sazvp-linux-pam-1.5.2/lib/security/pam_lastlog.so silent
      session optional /nix/store/8pbr7x6wh765mg43zs0p70gsaavmbbh7-systemd-253.3/lib/security/pam_systemd.so
      session optional /nix/store/21dqfghfa8b09ssvgja8l5bg7h5d9rzl-gnome-keyring-42.1/lib/security/pam_gnome_keyring.so auto_start
    '';

    polkit-1.text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth    sufficient    /root/lib/pam/pam_fprintd_grosshack.so
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
