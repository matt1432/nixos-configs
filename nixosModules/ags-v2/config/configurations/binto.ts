export default async() => {
    const { execAsync } = await import('astal');
    const { App } = await import('astal/gtk3');

    const style = (await import('../style/main.scss')).default;

    const AppLauncher = (await import('../widgets/applauncher/main')).default;
    const Bar = (await import('../widgets/bar/binto')).default;
    const Calendar = (await import('../widgets/date/binto')).default;
    const Clipboard = (await import('../widgets/clipboard/main')).default;
    const { NotifPopups, NotifCenter } = await import('../widgets/notifs/binto');
    const OSD = (await import('../widgets/osd/main')).default;
    const PowerMenu = (await import('../widgets/powermenu/main')).default;
    const Screenshot = (await import('../widgets/screenshot/main')).default;

    const { closeAll } = await import('../lib');
    const Brightness = (await import('../services/brightness')).default;
    const GSR = (await import('../services/gpu-screen-recorder')).default;
    const MonitorClicks = (await import('../services/monitor-clicks')).default;


    App.start({
        css: style,

        requestHandler(request, respond) {
            if (request.startsWith('open')) {
                App.get_window(request.replace('open ', ''))?.set_visible(true);
                respond('window opened');
            }
            else if (request.startsWith('closeAll')) {
                closeAll();
                respond('closed all windows');
            }
            else if (request.startsWith('fetchCapsState')) {
                Brightness.fetchCapsState();
                respond('fetched caps_lock state');
            }
            else if (request.startsWith('popup')) {
                popup_osd(request.replace('popup ', ''));
                respond('osd popped up');
            }
            else if (request.startsWith('save-replay')) {
                GSR.saveReplay();
                respond('saving replay');
            }
        },

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            AppLauncher();
            Bar();
            Calendar();
            Clipboard();
            NotifPopups();
            NotifCenter();
            OSD();
            PowerMenu();
            Screenshot();

            Brightness.initService({
                caps: 'input2::capslock',
            });
            new MonitorClicks();
        },
    });
};
