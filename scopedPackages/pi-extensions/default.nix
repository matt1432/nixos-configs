{pkgs, ...}:
pkgs.lib.makeScope pkgs.newScope (pi: {
  rpiv-web-tools = pi.callPackage ./rpiv-web-tools {};
})
