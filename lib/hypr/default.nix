{
  concatStringsSep,
  elemAt,
  optional,
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
        ++ optional (style != null) style
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
      ++ optional (command != null) command
    );

  mkMonitor = {
    description ? null,
    name ? null,
    resolution ? null,
    refreshRate ? null,
    position ? "auto",
    scale ? "1",
    transform ? null,
    mirror ? null,
    bitdepth ? null,
    vrr ? null,
  }: let
    transformMap = {
      "normal" = 0;
      "90" = 1;
      "180" = 2;
      "270" = 3;
      "normalf" = 4;
      "90f" = 5;
      "180f" = 6;
      "270f" = 7;
    };
  in
    concatStringsSep "," (
      [
        (
          if name != null && description != null
          then throw "description or name required"
          else if name != null
          then name
          else "desc:${description}"
        )
        (
          if resolution == null && refreshRate != null
          then throw "resolution needed if refreshRate is specified"
          else if resolution != null && refreshRate != null
          then "${resolution}@${toString refreshRate}"
          else if resolution != null && refreshRate == null
          then resolution
          else "preferred"
        )
        position
        scale
      ]
      ++ optional (transform != null) "transform, ${toString transformMap.${transform}}"
      ++ optional (mirror != null) "mirror, ${mirror}"
      ++ optional (bitdepth != null) "bitdepth, ${toString bitdepth}"
      ++ optional (vrr != null) "vrr, ${toString vrr}"
    );
}
