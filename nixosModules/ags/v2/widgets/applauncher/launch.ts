import { execAsync } from 'astal';

import AstalApps from 'gi://AstalApps';


const bash = async(strings: TemplateStringsArray | string, ...values: unknown[]) => {
    const cmd = typeof strings === 'string' ?
        strings :
        strings.flatMap((str, i) => `${str}${values[i] ?? ''}`)
            .join('');

    return execAsync(['bash', '-c', cmd]).catch((err) => {
        console.error(cmd, err);

        return '';
    });
};

export const launchApp = (app: AstalApps.Application) => {
    const exe = app.executable
        .split(/\s+/)
        .filter((str) => !str.startsWith('%') && !str.startsWith('@'))
        .join(' ');

    bash(`${exe} &`);
    app.frequency += 1;
};
