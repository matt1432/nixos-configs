import { execAsync, subprocess } from 'astal';
import GObject, { register } from 'astal/gobject';

/* Types */
interface NotifyAction {
    id: string
    label: string
    callback: () => void
}
interface NotifySendProps {
    actions?: NotifyAction[]
    appName?: string
    body?: string
    category?: string
    hint?: string
    iconName: string
    replaceId?: number
    title: string
    urgency?: 'low' | 'normal' | 'critical'
}


const APP_NAME = 'gpu-screen-recorder';
const ICON_NAME = 'nvidia';

const escapeShellArg = (arg: string): string => `'${arg.replace(/'/g, '\'\\\'\'')}'`;

const notifySend = ({
    actions = [],
    appName,
    body,
    category,
    hint,
    iconName,
    replaceId,
    title,
    urgency = 'normal',
}: NotifySendProps) => new Promise<number>((resolve) => {
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
    ].concat(
        actions.map(({ id, label }) => `--action=${escapeShellArg(id)}=${escapeShellArg(label)}`),
    ).join(' ');

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

@register()
export default class GSR extends GObject.Object {
    private _lastNotifID: number | undefined;

    public constructor() {
        super();

        try {
            subprocess(
                ['gsr-start'],
                (path) => {
                    if (!this._lastNotifID) {
                        console.error('[GSR] ID of warning notif not found');

                        setTimeout(() => {
                            this._onSaved(path);
                        }, 1000);
                    }
                    else {
                        this._onSaved(path);
                    }
                },
                () => { /**/ },
            );
        }
        catch (_e) {
            console.error('Missing dependency for gpu-screen-recorder');
        }
    }

    private static _default: InstanceType<typeof GSR> | undefined;

    public static get_default() {
        if (!GSR._default) {
            GSR._default = new GSR();
        }

        return GSR._default;
    }

    public saveReplay() {
        execAsync(['gpu-save-replay'])
            .then(async() => {
                this._lastNotifID = await notifySend({
                    appName: APP_NAME,
                    iconName: ICON_NAME,
                    title: 'Saving Replay',
                    body: 'Last 20 minutes',
                });
            })
            .catch((err) => {
                console.error(`[GSR save-replay] ${err}`);
            });
    }

    private _onSaved(path: string) {
        notifySend({
            appName: APP_NAME,
            iconName: ICON_NAME,
            replaceId: this._lastNotifID,

            title: 'Replay Saved',
            body: `Saved to ${path}`,

            actions: [
                {
                    id: 'folder',
                    label: 'Open Folder',

                    callback: () => execAsync([
                        'xdg-open',
                        path.substring(0, path.lastIndexOf('/')),
                    ]).catch(print),
                },

                {
                    id: 'video',
                    label: 'Open Video',

                    callback: () => execAsync(['xdg-open', path]).catch(print),
                },

                {
                    id: 'kdenlive',
                    label: 'Edit in kdenlive',

                    callback: () => execAsync([
                        'bash',
                        '-c',
                        `kdenlive -i ${path}`,
                    ]).catch(print),
                },
            ],
        });
    }
}
