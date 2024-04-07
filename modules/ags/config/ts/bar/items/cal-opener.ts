import CursorBox from '../../misc/cursorbox.ts';
import Clock from './clock';


export default () => CursorBox({
    class_name: 'toggle-off',

    on_primary_click_release: () => App.toggleWindow('win-calendar'),

    setup: (self) => {
        self.hook(App, (_, windowName, visible) => {
            if (windowName === 'win-calendar') {
                self.toggleClassName('toggle-on', visible);
            }
        });
    },

    child: Clock(),
});
