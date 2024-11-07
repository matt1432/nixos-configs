export default async() => {
    const { execAsync } = await import('astal');
    const { App } = await import('astal/gtk3');

    const style = (await import('../style/main.scss')).default;

    const AppLauncher = (await import('../widgets/applauncher/main')).default;
    const Bar = (await import('../widgets/bar/wim')).default;
    const BgFade = (await import('../widgets/bg-fade/main')).default;
    const Calendar = (await import('../widgets/date/main')).default;
    const Clipboard = (await import('../widgets/clipboard/main')).default;
    const Corners = (await import('../widgets/corners/main')).default;
    const IconBrowser = (await import('../widgets/icon-browser/main')).default;
    const { NotifPopups, NotifCenter } = await import('../widgets/notifs/main');
    const OSD = (await import('../widgets/osd/main')).default;
    const PowerMenu = (await import('../widgets/powermenu/main')).default;
    const Screenshot = (await import('../widgets/screenshot/main')).default;

    const { closeAll } = await import('../lib');
    const Brightness = (await import('../services/brightness')).default;
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
            else if (request.startsWith('Brightness.screen')) {
                Brightness.screen += parseFloat(request.replace('Brightness.screen ', ''));
                respond('screen brightness changed');
            }
            else if (request.startsWith('popup')) {
                popup_osd(request.replace('popup ', ''));
                respond('osd popped up');
            }
            else if (request.startsWith('osk')) {
                console.log(`TODO: ${request.replace('osk ', '')}`);
                respond('implement this');
            }
        },

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            AppLauncher();
            Bar();
            BgFade();
            Calendar();
            Clipboard();
            Corners();
            IconBrowser();
            NotifPopups();
            NotifCenter();
            OSD();
            PowerMenu();
            Screenshot();

            Brightness.initService({
                kbd: 'tpacpi::kbd_backlight',
                caps: 'input1::capslock',
            });
            new MonitorClicks();
        },
    });
};
