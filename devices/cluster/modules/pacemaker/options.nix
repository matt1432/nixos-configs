{
  config,
  lib,
  nixpkgs-pacemaker,
  pkgs,
  ...
}: let
  inherit
    (lib)
    attrNames
    attrValues
    concatMapStringsSep
    elemAt
    filterAttrs
    mkIf
    mkOption
    types
    ;
  inherit (builtins) toFile map listToAttrs;

  pacemakerPath = "services/cluster/pacemaker/default.nix";
  cfg = config.services.pacemaker;
in {
  disabledModules = [pacemakerPath];
  imports = ["${nixpkgs-pacemaker}/nixos/modules/${pacemakerPath}"];

  options.services.pacemaker = {
    networkInterface = mkOption {
      default = "eno1";
      type = types.str;
    };

    resources = mkOption {
      default = {};
      type = with types;
        attrsOf (submodule ({name, ...}: {
          options = {
            enable = mkOption {
              default = true;
              type = types.bool;
            };

            systemdName = mkOption {
              default = name;
              type = types.str;
            };

            virtualIp = mkOption {
              default = null;
              type = types.nullOr types.str;
            };

            dependsOn = mkOption {
              default = [];
              # TODO: implement dependsOn
              type = types.listOf types.str;
            };

            # TODO: Add extraResources, extraConstraints ...
          };
        }));
    };
  };

  config = mkIf cfg.enable {
    systemd.services = let
      mkVirtIp = res: ''
        <primitive class="ocf" id="${res.systemdName}vip" provider="heartbeat" type="IPaddr2">
            <instance_attributes id="${res.systemdName}vip-attrs">
                <nvpair
                    id="${res.systemdName}vip-attrs-cidr_netmask"
                    name="cidr_netmask"
                    value="24"
                />
                <nvpair
                    id="${res.systemdName}vip-attrs-ip"
                    name="ip"
                    value="${res.virtualIp}"
                />
                <nvpair
                    id="${res.systemdName}vip-attrs-nic"
                    name="nic"
                    value="${cfg.networkInterface}"
                />
            </instance_attributes>
            <operations>
                <op
                    id="${res.systemdName}vip-monitor-interval-30s"
                    interval="30s"
                    name="monitor"
                />
                <op
                    id="${res.systemdName}vip-start-interval-0s"
                    interval="0s"
                    name="start"
                    timeout="20s"
                />
                <op
                    id="${res.systemdName}vip-stop-interval-0s"
                    interval="0s"
                    name="stop"
                    timeout="20s"
                />
            </operations>
        </primitive>
      '';

      mkSystemdResource = res: ''
        <primitive id="${res.systemdName}" class="systemd" type="${res.systemdName}">
            <operations>
                <op id="stop-${res.systemdName}" name="stop" interval="0" timeout="10s"/>
                <op id="start-${res.systemdName}" name="start" interval="0" timeout="10s"/>
                <op id="monitor-${res.systemdName}" name="monitor" interval="10s" timeout="20s"/>
            </operations>
        </primitive>
      '';

      mkConstraint = first: res: ''
        <rsc_order
            id="order-${res.systemdName}"
            first="${first}"
            then="${res.systemdName}"
            kind="Mandatory"
        />
        <rsc_colocation
            id="colocate-${res.systemdName}"
            rsc="${first}"
            with-rsc="${res.systemdName}"
            score="INFINITY"
        />
      '';

      mkVipConstraint = res:
        mkConstraint
        (res.systemdName + "vip")
        res;

      # If we're updating resources we have to kill constraints to add new resources
      constraintsEmpty = toFile "constraints.xml" ''
        <constraints>
        </constraints>
      '';

      resEnabled = filterAttrs (n: v: v.enable) cfg.resources;

      resWithIp = filterAttrs (n: v: ! isNull v.virtualIp) resEnabled;

      resources = toFile "resources.xml" ''
        <resources>
            ${concatMapStringsSep "\n" mkVirtIp (attrValues resWithIp)}
            ${concatMapStringsSep "\n" mkSystemdResource (attrValues resEnabled)}
        </resources>
      '';

      constraints = toFile "constraints.xml" ''
        <constraints>
            ${concatMapStringsSep "\n" mkVipConstraint (attrValues resWithIp)}
        </constraints>
      '';

      host1 = (elemAt config.services.corosync.nodelist 0).name;
    in
      {
        "pacemaker-setup" = {
          after = ["corosync.service" "pacemaker.service"];

          path = with pkgs; [pacemaker];

          script = ''
            # The config needs to be installed from one node only
            if [ "$(uname -n)" = ${host1} ]; then
                # TODO: setup stonith / fencing
                crm_attribute --type crm_config --name stonith-enabled --update false
                crm_attribute --type crm_config --name no-quorum-policy --delete

                # Install config
                cibadmin --replace --scope constraints --xml-file ${constraintsEmpty}
                cibadmin --replace --scope resources --xml-file ${resources}
                cibadmin --replace --scope constraints --xml-file ${constraints}
            fi
          '';
        };
      }
      # Force all systemd units handled by pacemaker to not start automatically
      // listToAttrs (map (x: {
        name = x;
        value = {
          wantedBy = lib.mkForce [];
        };
      }) (attrNames cfg.resources));

    # FIXME: https://github.com/NixOS/nixpkgs/pull/208298
    nixpkgs.overlays = [
      (final: prev: {
        inherit
          (nixpkgs-pacemaker.legacyPackages.x86_64-linux)
          pacemaker
          ocf-resource-agents
          ;
      })
    ];
  };
}