import GLib from 'gi://GLib';


(await import(`./configurations/${GLib.getenv('CONF')}.ts`)).default();
