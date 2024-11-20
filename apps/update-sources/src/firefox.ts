import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';


/* Constants */
const FLAKE = process.env.FLAKE;

export const updateFirefoxAddons = () => {
    console.log('Updating firefox addons using mozilla-addons-to-nix');

    const DIR = `${FLAKE}/scopedPackages/firefox-addons`;
    const GENERATED_FILE = `${DIR}/generated-firefox-addons.nix`;
    const SLUGS = `${DIR}/addons.json`;

    const nameMap = Object.fromEntries([...JSON.parse(readFileSync(SLUGS, 'utf-8'))]
        .map((addon) => [addon.slug, addon.pname || addon.slug]));

    const nixExpr = `'
        x: let
          inherit (builtins) attrValues filter hasAttr isAttrs map;
        in
          map (d: d.name) (filter (y:
            isAttrs y &&
            hasAttr "type" y &&
            y.type == "derivation") (attrValues x))
    '`;

    const OLD_VERS = Object.fromEntries([...JSON.parse(spawnSync('nix', [
        'eval',
        '.#scopedPackages.x86_64-linux.firefoxAddons',
        '--apply',
        nixExpr,
        '--json',
    ], { shell: true }).stdout.toString())]
        .map((p) => {
            const pname = p.replace(/-[0-9].*$/, '');

            return [pname, p.replace(`${pname}-`, '')];
        })
        .filter((pinfo) => pinfo[0] !== 'frankerfacez'));

    const NEW_VERS = Object.fromEntries(spawnSync(
        'nix',
        ['run', 'sourcehut:~rycee/mozilla-addons-to-nix',
            SLUGS, GENERATED_FILE],
        { shell: true },
    ).stdout
        .toString()
        .split('\n')
        .map((p) => {
            const pinfo = p.replace('Fetched ', '').split(' ');

            return [nameMap[pinfo[0]], pinfo[2]];
        }));

    return Object.keys(OLD_VERS)
        .sort()
        .filter((pname) => OLD_VERS[pname] !== NEW_VERS[pname])
        .map((pname) => `${pname}: ${OLD_VERS[pname]} -> ${NEW_VERS[pname]}`)
        .join('\n');
};
