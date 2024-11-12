export default async() => {
    const { execAsync } = await import('astal');
    const { App } = await import('astal/gtk3');

    const Greeter = (await import('../widgets/greeter/main')).default;

    const style = (await import('../style/greeter.scss')).default;


    App.start({
        css: style,
        instanceName: 'greeter',

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            Greeter();
        },
    });
};
