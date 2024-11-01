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

    globalThis.closeAll = closeAll;
    globalThis.Brightness = Brightness;


    App.start({
        css: style,

        requestHandler(js, res) {
            App.eval(js).then(res).catch(res);
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

            setTimeout(() => {
                App.get_window('win-applauncher')?.set_visible(true);
            }, 3 * 1000);
        },
    });
};
