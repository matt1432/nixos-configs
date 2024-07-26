Utils.execAsync('hyprpaper');

import Greeter from './ts/greetd/main.ts';

App.config({
    style: './style.css',

    windows: () => [
        Greeter(),
    ],
});
