import Greeter from './ts/greetd/main';

App.config({
    windows: () => [
        Greeter(),
    ],
});
