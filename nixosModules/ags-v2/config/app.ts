// TODO: persisting data like bluetooth
// TODO: quick-settings
// TODO: music player stuff
// TODO: on-screen-keyboard
// TODO: Greetd
// TODO: GSR

import GLib from 'gi://GLib';


(await import(`./configurations/${GLib.getenv('CONF')}.ts`)).default();
