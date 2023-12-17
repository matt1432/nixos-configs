{
  fetchFromGitHub,
  buildLua,
}:
buildLua rec {
  pname = "undo-redo";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "Eisa01";
    repo = "mpv-scripts";
    rev = "48d68283cea47ff8e904decc9003b3abc3e2123e";
    hash = "sha256-95CAKjBRELX2f7oWSHFWJnI0mikAoxhfUphe9k51Qf4=";
  };
  scriptPath = "${src}/scripts/UndoRedo.lua";
}
