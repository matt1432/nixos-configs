/* Types */
import { Application } from 'types/service/applications.ts';


const bash = async(strings: TemplateStringsArray | string, ...values: unknown[]) => {
    const cmd = typeof strings === 'string' ?
        strings :
        strings.flatMap((str, i) => `${str}${values[i] ?? ''}`)
            .join('');

    return Utils.execAsync(['bash', '-c', cmd]).catch((err) => {
        console.error(cmd, err);

        return '';
    });
};

export const launchApp = (app: Application) => {
    const exe = app.executable
        .split(/\s+/)
        .filter((str) => !str.startsWith('%') && !str.startsWith('@'))
        .join(' ');

    bash(`${exe} &`);
    app.frequency += 1;
};
