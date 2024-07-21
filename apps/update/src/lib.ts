import { spawnSync } from 'node:child_process';


export const parseArgs = () => {
    const args = {} as Record<string, unknown>;
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

export const parseFetchurl = (url: string) => JSON.parse(spawnSync(
    'nix', ['store', 'prefetch-file', '--refresh', '--json',
        '--hash-type', 'sha256', url, '--name', '"escaped"'], { shell: true },
).stdout.toString()).hash;
