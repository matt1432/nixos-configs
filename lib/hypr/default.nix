{
  elemAt,
  mapAttrsToList,
  mkLuaInline,
  optional,
  ...
}: rec {
  pointToArr = p: [(elemAt p 0) (elemAt p 1)];

  mkBezier = {
    name,
    p0,
    p1,
  }: {
    _args = [
      name
      {
        type = "bezier";
        points = [(pointToArr p0) (pointToArr p1)];
      }
    ];
  };

  mkBind = {
    keys,
    dispatcher,
    flags ? null,
  }: {
    _args =
      [
        keys
        (mkLuaInline dispatcher)
      ]
      ++ optional (flags != null) flags;
  };

  mkEnvs = mapAttrsToList (n: v: {
    _args = [n v];
  });

  mkExecOnce = cmd: {
    _args = [
      "hyprland.start"
      (mkLuaInline ''
        function()
          ${cmd}
        end
      '')
    ];
  };
}
