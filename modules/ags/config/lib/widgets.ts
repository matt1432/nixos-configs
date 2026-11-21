import { Gdk, Gtk } from 'ags/gtk4';

const providers = new WeakMap<Gtk.Widget, Gtk.CssProvider>();

/**
 * Sets the widget-local CSS of a widget, replacing whatever was
 * previously set through this function.
 *
 * @param object the widget to style
 * @param css    either declarations or a full stylesheet
 */
export const setCss = (object: Gtk.Widget, css: string) => {
    if (!(object instanceof Gtk.Widget)) {
        console.warn(Error(`cannot set css on ${object}`));

        return;
    }

    const ctx = object.get_style_context();

    if (!css.includes('{') || !css.includes('}')) {
        // GTK4 wants the last declaration to be terminated
        css = css.trim();
        css = `* { ${css}${css.endsWith(';') ? '' : ';'} }`;
    }

    const oldProvider = providers.get(object);

    if (oldProvider) {
        ctx.remove_provider(oldProvider);
    }

    const provider = new Gtk.CssProvider();

    provider.load_from_string(css);
    ctx.add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
    providers.set(object, provider);
};

export const toggleClassName = (
    object: Gtk.Widget,
    className: string,
    enabled: boolean,
) => {
    if (enabled) {
        object.add_css_class(className);
    }
    else {
        object.remove_css_class(className);
    }
};

const cursorCache = new Map<string, Gdk.Cursor>();

/**
 * @param name a CSS cursor name like `pointer` or `grab`
 * @returns a cached Gdk.Cursor to pass to a widget's `cursor` prop
 */
export const cursor = (name: string): Gdk.Cursor => {
    let c = cursorCache.get(name);

    if (!c) {
        c = Gdk.Cursor.new_from_name(name, null) as Gdk.Cursor;
        cursorCache.set(name, c);
    }

    return c;
};

export const pointer = cursor('pointer');

/**
 * @param widget a widget
 * @returns the direct children of a widget
 */
export const getChildren = (widget: Gtk.Widget): Gtk.Widget[] => {
    const children: Gtk.Widget[] = [];

    for (
        let child = widget.get_first_child();
        child;
        child = child.get_next_sibling()
    ) {
        children.push(child);
    }

    return children;
};
