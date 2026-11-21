import { register } from 'ags/gobject';
import { Gdk, Gtk } from 'ags/gtk4';
import { intrinsicElements } from 'ags/gtk4/jsx-runtime';
import Gio from 'gi://Gio';

/*
 * Some icon themes (like Flat-Remix) have a padded, differently drawn set of
 * symbolic icons for 20-24px (their `panel` directory) that GTK4 picks at those
 * sizes, which makes icons look smaller than in GTK3. For symbolic icons,
 * this uses the regular icon file instead and lets it scale to the CSS size.
 */

const REFERENCE_SIZE = 16;

const resolveSymbolic = (name: string): Gio.File | null => {
    const display = Gdk.Display.get_default();

    if (!display || !name.endsWith('-symbolic')) {
        return null;
    }

    const theme = Gtk.IconTheme.get_for_display(display);

    if (!theme.has_icon(name)) {
        return null;
    }

    return theme
        .lookup_icon(
            name,
            null,
            REFERENCE_SIZE,
            1,
            Gtk.TextDirection.NONE,
            0 as Gtk.IconLookupFlags,
        )
        .get_file();
};

@register()
export class Icon extends Gtk.Image {
    private resolving = false;

    constructor(props: Partial<Gtk.Image.ConstructorProps> = {}) {
        super(props);

        this.resolve();
        this.connect('notify::icon-name', () => this.resolve());
    }

    private resolve() {
        if (this.resolving || !this.iconName) {
            return;
        }

        const file = resolveSymbolic(this.iconName);

        if (file) {
            this.resolving = true;
            // Files named *-symbolic.svg are still recolored like symbolic icons
            this.set_from_gicon(new Gio.FileIcon({ file }));
            this.resolving = false;
        }
    }
}

// Every <image> in the config goes through this
intrinsicElements['image'] = Icon;

export default Icon;
