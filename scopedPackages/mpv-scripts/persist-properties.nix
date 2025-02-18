{
  # nix build inputs
  lib,
  buildLua,
  mkVersion,
  mpv-persist-properties-src,
  ...
}:
buildLua {
  pname = "persist-properties";
  version = mkVersion mpv-persist-properties-src;

  src = mpv-persist-properties-src;

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/d87/mpv-persist-properties";
    description = ''
      Keeps selected property values (like volume) between player sessions.
    '';
  };
}
