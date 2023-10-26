{ vimUtils
, buildNpmPackage
, fetchFromGitHub
}: let
  buildVimPlugin = vimUtils.buildVimPlugin;
  name = "coc-stylelintplus";
  rev = "7945d0c2a26da13b7d1aa6e0681ddac088b22d3b";

  nodePkg = buildNpmPackage {
    name = name;
    src = fetchFromGitHub {
      owner = "matt1432";
      repo = name;
      rev = rev;
      hash = "sha256-tdNE0taHuvZ7Gg9RXz5TWKB/ujpGO1tMzWHIj3O9vOw=";
    };

    npmDepsHash = "sha256-r9JdzGjdf36vyRQeGDt0ZttF/PSCQBYfn472EiSpEXg=";

    dontNpmBuild = true;
    makeCacheWritable = true;
  };
in
buildVimPlugin {
  pname = name;
  version = rev;
  src = "${nodePkg}/lib/node_modules/${name}";
}
