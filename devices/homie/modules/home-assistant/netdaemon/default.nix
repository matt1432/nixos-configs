{
  config,
  self,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  compiled = pkgs.callPackage ./package.nix {};
in {
  khepri.compositions."netdaemon" = {
    networks.netdaemon = {external = true;};

    services."netdaemon4" = {
      image = import ./images/netdaemon.nix pkgs;
      restart = "always";

      environmentFiles = [secrets.netdaemon.path];
      environment = {
        HomeAssistant__Host = "homie.nelim.org";
        HomeAssistant__Port = "443";
        HomeAssistant__Ssl = "true";
        NetDaemon__ApplicationAssembly = "netdaemon.dll";
        Logging__LogLevel__Default = "Information"; # use Information/Debug/Trace/Warning/Error
        TZ = "America/New_York";
      };

      volumes = ["${compiled}/lib/netdaemon-config:/data"];
      networks = ["netdaemon"];
    };
  };

  services.home-assistant = {
    customComponents = builtins.attrValues {
      inherit
        (self.legacyPackages.${pkgs.system}.hass-components)
        netdaemon
        ;
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "updateNuDeps";
      runtimeInputs = [pkgs.dotnet-sdk_8];
      text = ''
        # Update the codegen
        dotnet tool update -g NetDaemon.HassModel.CodeGen

        # Update all nugets to latest versions
        regex='PackageReference Include="([^"]*)" Version="([^"]*)"'

        find . -type f -name '*.csproj' | while read -r file; do
            # Extract unique package names from the .csproj file
            packages=$(grep -oP "$regex" "$file" | sed -E 's/.*Include="([^"]*)".*/\1/' | sort -u)

            # Loop through each package and update
            for package in $packages; do
                echo -e "\033[35mUpdate $file package: $package\033[0m"
                dotnet add "$file" package "$package"
            done
        done

        ${compiled.passthru.fetch-deps} .
      '';
    })
  ];
}
