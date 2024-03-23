import Adw from 'gi://Adw';


App.config({
    windows: () => [
        Widget.Window({
            name: 'test',

            child: Widget.Box({
                setup: (self) => {
                    self.toggleCssClass('base');
                },

                child: new Adw.SplitButton({
                    label: 'test',
                }),
            }),
        }),
    ],
});
