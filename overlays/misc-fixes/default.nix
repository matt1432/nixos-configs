final: prev: {
  # NOTE: https://nixpkgs-tracker.ocfox.me/?pr=586820
  linuxPackages_zen = final.linuxPackagesFor (prev.linuxPackages_zen.kernel.override (o: {
    kernelPatches =
      (o.kernelPatches or [])
      ++ [
        {
          name = "zen-workqueue-null-deref";
          patch = ./zen-workqueue-null-deref.patch;
        }
      ];
  }));
}
