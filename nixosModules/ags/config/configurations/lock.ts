export default async() => {
    const { App } = await import('astal/gtk3');

    const Lockscreen = (await import('../widgets/lockscreen/main')).default;

    const style = (await import('../style/lock.scss')).default;


    App.start({
        css: style,
        instanceName: 'lock',

        requestHandler(js, res) {
            App.eval(js).then(res).catch(res);
        },

        main: () => {
            Lockscreen();
        },
    });
};
