import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';

/* Constants */
const FLAKE = process.env.FLAKE;

const getAttrVersion = (attr: string): string => {
    return spawnSync('nix', [
        'eval',
        '--raw',
        `${FLAKE}#${attr}.version`,
    ]).stdout.toString();
};

/*
    The type of a package's passthru.updateScript tells us how to update it:
    - "string" or "path"      -> custom shell script (getExe or ./update.sh)
    - "list" with nix-update  -> generic nix-update-script: [nix-update, extraArgs]
    - "list" otherwise        -> custom script wrapped in a list, which invokes
      nix-update itself; run it with -u since a generic update would resolve
      the wrong version for these
    - "derivation" or missing -> update generically
*/
const getUpdateScript = (attr: string): 'custom' | 'generic' | null => {
    const type = spawnSync('nix', [
        'eval',
        '--raw',
        '--apply',
        'x: builtins.typeOf x',
        `${FLAKE}#${attr}.passthru.updateScript`,
    ])
        .stdout.toString()
        .trim();

    if (type === 'string' || type === 'path') {
        return 'custom';
    }

    if (type !== 'list') {
        return null;
    }

    const elements = spawnSync('nix', [
        'eval',
        '--raw',
        '--apply',
        'x: builtins.concatStringsSep "\n" x',
        `${FLAKE}#${attr}.passthru.updateScript`,
    ])
        .stdout.toString()
        .split('\n');

    return elements.some((element) => element.endsWith('/bin/nix-update'))
        ? 'generic'
        : 'custom';
};

const hasSrcUrl = (attr: string): boolean =>
    spawnSync('nix', ['eval', '--raw', `${FLAKE}#${attr}.src.url`]).status ===
    0;

const getPackageFile = (
    attr: string,
    scope?: string,
    scopeAttr?: string,
): string =>
    scope
        ? `scopedPackages/${scope.replace(/([A-Z])/g, '-$1').toLowerCase()}/${scopeAttr}/default.nix`
        : `packages/${attr}/default.nix`;

export default (
    attr: string,
    scope?: string,
    scopeAttr?: string,
): string | null => {
    const realAttr = scope
        ? `${attr}.x86_64-linux.${scope}.${scopeAttr}`
        : attr;
    const cleanAttr = scope ? `${attr}.${scope}.${scopeAttr}` : attr;

    console.log(styleText(['magenta'], `\nUpdating ${cleanAttr}:\n`));

    const OLD_VERSION = getAttrVersion(realAttr);

    const updateArgs = ['--flake', realAttr];

    // Nix omits the "path" field from `nix flake metadata --json`, so
    // nix-update cannot pin the flake store path and position sanitization
    // fails ("... is not in /nix/store/..."). Override the filename to
    // disable position sanitization entirely.
    updateArgs.push(
        '--override-filename',
        getPackageFile(attr, scope, scopeAttr),
    );

    const script = getUpdateScript(realAttr);

    if (script === 'custom') {
        updateArgs.push('-u');
    }
    else if (script === 'generic' && !hasSrcUrl(realAttr)) {
        // Generic nix-update-scripts re-invoke plain nix-update, which fails
        // on this flake. Without a fetcher url there is no version to bump,
        // so update dependency hashes (e.g. npmDepsHash) only.
        updateArgs.push('--version', 'skip');
    }

    spawnSync('nix-update', updateArgs, {
        cwd: FLAKE,
        stdio: ['inherit', 'ignore', 'inherit'],
    });

    const NEW_VERSION = getAttrVersion(realAttr);

    return OLD_VERSION !== NEW_VERSION
        ? `${cleanAttr}: ${OLD_VERSION} -> ${NEW_VERSION}`
        : null;
};
