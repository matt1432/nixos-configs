import GObject, { register } from 'ags/gobject';
import { execAsync, subprocess } from 'ags/process';

import { notifySend } from '../lib';

const APP_NAME = 'gpu-screen-recorder';
const ICON_NAME = 'nvidia';

@register()
export default class GpuScreenRecorder extends GObject.Object {
    private _lastNotifID: number | undefined = undefined;

    public constructor() {
        super();

        try {
            subprocess(
                ['gsr-start'],
                (path) => {
                    if (!this._lastNotifID) {
                        console.error(
                            '[GpuScreenRecorder] ID of warning notif not found',
                        );

                        setTimeout(() => {
                            this._onSaved(path);
                        }, 1000);
                    }
                    else {
                        this._onSaved(path);
                    }
                },
                () => {},
            );
        }
        catch (_e) {
            console.error('Missing dependency for gpu-screen-recorder');
        }
    }

    private static _default: InstanceType<typeof GpuScreenRecorder> | undefined;

    public static get_default() {
        if (!GpuScreenRecorder._default) {
            GpuScreenRecorder._default = new GpuScreenRecorder();
        }

        return GpuScreenRecorder._default;
    }

    public saveReplay() {
        execAsync(['gpu-save-replay'])
            .then(async () => {
                this._lastNotifID = await notifySend({
                    appName: APP_NAME,
                    iconName: ICON_NAME,
                    title: 'Saving Replay',
                    body: 'Last 20 minutes',
                });
            })
            .catch((err) => {
                console.error(`[GpuScreenRecorder save-replay] ${err}`);
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

                    callback: () =>
                        execAsync([
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

                    callback: () =>
                        execAsync(['bash', '-c', `kdenlive -i ${path}`]).catch(
                            print,
                        ),
                },
            ],
        });
    }
}
