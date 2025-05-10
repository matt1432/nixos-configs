import { spawnSync } from 'node:child_process';
import { readFileSync, writeFileSync } from 'node:fs';

/* Types */
interface Args {
    f: string | undefined
    [name: string]: unknown
}


export const parseArgs = (): Args => {
    const args = {} as Args;
    let lastFlag: string | null = null;

    for (let i = 2; i < process.argv.length; ++i) {
        const arg = process.argv[i];

        if (arg.toString().startsWith('-')) {
            lastFlag = arg.toString().replace(/^-{1,2}/, '');
            args[lastFlag] = true;
        }
        else if (lastFlag) {
            args[lastFlag] = arg;
            lastFlag = null;
        }
        else {
            console.error(`Could not parse args: ${arg.toString()}`);
        }
    }

    return args;
};

export const parseFetchurl = (url: string): string => JSON.parse(spawnSync(
    ['nix', 'store', 'prefetch-file', '--refresh', '--json',
        '--hash-type', 'sha256', url, '--name', '"escaped"'].join(' '), [], { shell: true },
).stdout.toString()).hash;

export const replaceInFile = (replace: RegExp, replacement: string, file: string): void => {
    const fileContents = readFileSync(file);

    const replaced = fileContents.toString().replace(replace, replacement);

    writeFileSync(file, replaced);
};

export const npmRun = (args: string[], workspaceDir: string): string => spawnSync(
    'npm', args, { cwd: workspaceDir },
).stdout.toString();
