{
  fetchFromGitHub,
  buildLua,
}:
buildLua {
  pname = "touch-gestures";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-touch-gestures";
    rev = "f4aa499f038997c1824ff3bfa64ee1d5438d72f2";
    hash = "sha256-gmo6sTwN85WS/+wtlylfI22LxyZH48DvXYP5JGCnyU4=";
  };
}
