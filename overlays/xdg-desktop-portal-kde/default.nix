(final: prev: {
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    xdg-desktop-portal-kde = kprev.xdg-desktop-portal-kde.overrideAttrs (o: {
      patches = let
        rdpPatch =
          if o.version == "6.1.3"
          then ./6-1-3.patch
          else if builtins.compareVersions o.version "6.3.0" == -1
          then ./6-2.patch
          else throw "This patch is not working or needed anymore. Please see https://develop.kde.org/docs/administration/portal-permissions/";
      in
        (o.patches or [])
        ++ [
          # https://invent.kde.org/plasma/xdg-desktop-portal-kde/-/issues/15#note_906047
          rdpPatch
        ];
    });
  });
})
