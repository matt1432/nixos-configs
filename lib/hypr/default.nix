{
  concatStringsSep,
  elemAt,
  optionals,
  ...
}: rec {
  pointToStr = p: "${toString (elemAt p 0)}, ${toString (elemAt p 1)}";

  mkBezier = {
    name,
    p0,
    p1,
  }:
    concatStringsSep "," [name (pointToStr p0) (pointToStr p1)];

  mkAnimation = {
    name,
    enable ? true,
    duration ? 0, # in ds (100ms)
    bezier ? "default",
    style ? null,
  }:
    concatStringsSep "," (
      [
        name
        (
          if enable
          then "1"
          else "0"
        )
      ]
      ++ optionals enable (
        [
          (toString duration)
          bezier
        ]
        ++ optionals (style != null) [style]
      )
    );

  mkLayerRule = {
    rule,
    namespace,
  }:
    concatStringsSep "," [rule namespace];

  mkBind = {
    modifier ? "",
    key,
    dispatcher ? "exec",
    command ? null,
  }:
    concatStringsSep "," (
      [modifier key dispatcher]
      ++ optionals (command != null) [command]
    );
}
