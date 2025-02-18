{
  # nix build inputs
  lib,
  buildLua,
  mkVersion,
  mpv-pointer-event-src,
  ...
}:
buildLua {
  pname = "pointer-event";
  version = mkVersion mpv-pointer-event-src;

  src = mpv-pointer-event-src;

  meta = {
    license = lib.licenses.gpl2;
    homepage = "https://github.com/christoph-heinrich/mpv-pointer-event";
    description = ''
      Mouse/Touch input event detection for mpv.
    '';
  };
}
