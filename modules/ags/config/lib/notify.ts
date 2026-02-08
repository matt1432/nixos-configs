import { subprocess } from 'astal';

/* Types */
interface NotifyAction {
    id: string;
    label: string;
    callback: () => void;
}
interface NotifySendProps {
    actions?: NotifyAction[];
    appName?: string;
    body?: string;
    category?: string;
    hint?: string;
    iconName: string;
    replaceId?: number;
    title: string;
    urgency?: 'low' | 'normal' | 'critical';
}

const escapeShellArg = (arg: string | undefined): string => {
    return `'${arg?.replace(/'/g, "'\\''") ?? ''}'`;
};

export const notifySend = ({
    actions = [],
    appName,
    body,
    category,
    hint,
    iconName,
    replaceId,
    title,
    urgency = 'normal',
}: NotifySendProps) => {
    return new Promise<number>((resolve) => {
        let printedId = false;

        const cmd = [
            'notify-send',
            '--print-id',
            `--icon=${escapeShellArg(iconName)}`,
            escapeShellArg(title),
            escapeShellArg(body ?? ''),
            // Optional params
            appName ? `--app-name=${escapeShellArg(appName)}` : '',
            category ? `--category=${escapeShellArg(category)}` : '',
            hint ? `--hint=${escapeShellArg(hint)}` : '',
            replaceId ? `--replace-id=${replaceId.toString()}` : '',
            `--urgency=${urgency}`,
        ]
            .concat(
                actions.map(
                    ({ id, label }) =>
                        `--action=${escapeShellArg(id)}=${escapeShellArg(label)}`,
                ),
            )
            .join(' ');

        subprocess(
            cmd,
            (out) => {
                if (!printedId) {
                    resolve(parseInt(out));
                    printedId = true;
                }
                else {
                    actions.find((action) => action.id === out)?.callback();
                }
            },
            (err) => {
                console.error(`[Notify] ${err}`);
            },
        );
    });
};
