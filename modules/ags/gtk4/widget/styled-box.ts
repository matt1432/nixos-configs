import { astalify, Gtk } from 'astal/gtk4';
import { property, register } from 'astal';


@register({ GTypeName: 'StyledBox' })
class StyledBoxClass extends Gtk.Box {
    declare private _css: string | undefined;
    declare private _provider: Gtk.CssProvider | undefined;

    @property(String)
    get css(): string | undefined {
        return this._css;
    }

    set css(value: string) {
        if (!this._provider) {
            this._provider = new Gtk.CssProvider();

            this.get_style_context().add_provider(
                this._provider,
                Gtk.STYLE_PROVIDER_PRIORITY_USER,
            );
        }

        this._css = value;
        this._provider.load_from_string(value);
    }
}

export type StyledBox = StyledBoxClass;
export const StyledBox = astalify<
    StyledBoxClass,
    Gtk.Box.ConstructorProps & { css: string }
>(StyledBoxClass);
