const { execAsync, subprocess } = Utils;

const Notifications = await Service.import('notifications');

const APP_NAME = 'gpu-screen-recorder';
const START_APP_ID = 2345;
const ICON_NAME = 'nvidia';


class GSR extends Service {
    static {
        Service.register(this, {}, {});
    }

    #appID = START_APP_ID;

    constructor() {
        super();

        subprocess(
            ['gsr-start'],
            (path) => {
                Notifications.getNotification(this.#appID)?.close();

                const notifId = Notifications.Notify(
                    APP_NAME,
                    ++this.#appID,
                    ICON_NAME,
                    'Replay Saved',
                    `Saved to ${path}`,
                    ['folder', 'Open Folder', 'video', 'Open Video', 'kdenlive', 'Edit in kdenlive'],
                    {},
                    Notifications.popupTimeout,
                );

                Notifications.getNotification(notifId)?.connect(
                    'invoked',
                    (_, actionId: string) => {
                        if (actionId === 'folder') {
                            execAsync([
                                'xdg-open',
                                path.substring(0, path.lastIndexOf('/')),
                            ]).catch(print);
                        }

                        else if (actionId === 'video') {
                            execAsync(['xdg-open', path]).catch(print);
                        }

                        else if (actionId === 'kdenlive') {
                            execAsync([
                                'bash',
                                '-c',
                                `kdenlive -i ${path}`,
                            ]).catch(print);
                        }
                    },
                );
            },
            () => { /**/ },
        );
    }

    saveReplay() {
        execAsync(['gpu-save-replay']).then(() => {
            Notifications.Notify(
                APP_NAME,
                this.#appID,
                ICON_NAME,
                'Saving Replay',
                'Last 20 minutes',
                [],
                {},
                Notifications.popupTimeout,
            );
        }).catch(console.error);
    }
}

export default GSR;
