import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';

/* Constants */
const FLAKE = process.env.FLAKE;

const getAttrVersion = (attr: string): string =>
    spawnSync(
        ['nix', 'eval', '--raw', `${FLAKE}#${attr}.version`].join(' '),
        [],
        { shell: true },
    ).stdout.toString();

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

    spawnSync('nix-update', ['--flake', realAttr, '-u'], {
        cwd: FLAKE,
        stdio: ['inherit', 'ignore', 'inherit'],
    });

    const NEW_VERSION = getAttrVersion(realAttr);

    return OLD_VERSION !== NEW_VERSION
        ? `${cleanAttr}: ${OLD_VERSION} -> ${NEW_VERSION}`
        : null;
};
