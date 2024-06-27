{pkgs, ...}: {
  programs.bash.shellAliases = {
    # https://wiki.hyprland.org/Contributing-and-Debugging/#lsp-and-formatting
    "mkCMakeFiles" = "cmake -S . -B build/ -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON";
  };

  home.packages = [
    (pkgs.writeShellScriptBin "testChanges" ''
      rm -r /home/matt/git/$1/$2/{.cache,build}
      nix flake update "$1"
      nh os switch
      (
          cd "/home/matt/git/$1/$2"
          nix develop /home/matt/git/$1 -c cmake -S . -B build/ -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      )
    '')
  ];
}
