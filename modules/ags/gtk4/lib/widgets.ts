import { Gtk } from 'ags/gtk4';

export const setCss = (object: Gtk.Widget, css: string) => {
    if (!(object instanceof Gtk.Widget)) {
        return console.warn(Error(`cannot set css on ${object}`));
    }

    const ctx = object.get_style_context();
    if (!css.includes('{') || !css.includes('}')) {
        css = `* { ${css} }`;
    }

    const provider = new Gtk.CssProvider();

    provider.load_from_string(css);
    ctx.add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
};

export const toggleClassName = (
    object: Gtk.Widget,
    className: string,
    enabled: boolean,
) => {
    const ctx = object.get_style_context();

    if (enabled) {
        if (!ctx.has_class(className)) {
            ctx.add_class(className);
        }
    }
    else if (ctx.has_class(className)) {
        ctx.remove_class(className);
    }
};
