import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';


/* Constants */
const FLAKE = process.env.FLAKE;

const getAttrVersion = (attr: string): string => spawnSync('nix',
    ['eval', '--raw', `${FLAKE}#${attr}.version`],
    { shell: true }).stdout.toString();

export default (
    attr: string,
    scope?: string,
    scopeAttr?: string,
): {
    changelog: string | null
    stdout: string
    stderr: string
} => {
    const realAttr = scope ? `${attr}.x86_64-linux.${scope}.${scopeAttr}` : attr;
    const cleanAttr = scope ? `${attr}.${scope}.${scopeAttr}` : attr;

    console.log(styleText(['magenta'], `\nUpdating ${realAttr}:\n`));

    const OLD_VERSION = getAttrVersion(realAttr);

    const execution = spawnSync('nix-update', ['--flake', realAttr, '-u'], { cwd: FLAKE });

    const NEW_VERSION = getAttrVersion(realAttr);

    return {
        changelog: OLD_VERSION !== NEW_VERSION ?
            `${cleanAttr}: ${OLD_VERSION} -> ${NEW_VERSION}` :
            null,
        stdout: execution.stdout.toString(),
        stderr: execution.stderr.toString(),
    };
};
