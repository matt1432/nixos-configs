import { Gtk } from 'ags/gtk3';

export const setCss = (provider: Gtk.CssProvider, css: string) => {
    if (!css.includes('{') || !css.includes('}')) {
        css = `* { ${css} }`;
    }

    provider.load_from_data(new TextEncoder().encode(css));
};

export const getCssProvider = (object: Gtk.Widget) => {
    const ctx = object.get_style_context();
    const provider = new Gtk.CssProvider();
    ctx.add_provider(provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
    return provider;
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
