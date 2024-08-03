const Hyprland = await Service.import('hyprland');

const { Box, Entry, Icon, Label, ListBox, Revealer, Scrollable } = Widget;

/* Types */
import { PopupWindow, PopupWindowProps } from '../misc/popup.ts';
import type { Widget as AgsWidget } from 'types/widgets/widget';
import { ListBoxRow } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import { Monitor } from 'types/service/hyprland';
import { Binding } from 'types/service';

// eslint-disable-next-line @typescript-eslint/no-empty-object-type
export interface SortedList<Attr> extends AgsWidget<Attr> { }

// eslint-disable-next-line no-use-before-define
type MakeChild = ReturnType<typeof makeChild>;

type SortedListProps<Attr = unknown, Self = SortedList<Attr>> =
  PopupWindowProps<MakeChild['child'], Attr, Self> & {
      on_select?: (row: ListBoxRow) => void
      init_rows?: (list: MakeChild['list']) => void
      on_text_change?: (
          text: string,
          list: MakeChild['list'],
          placeholder: MakeChild['placeholder'],
      ) => void
      setup_list?: (list: MakeChild['list'], entry: MakeChild['entry']) => void
  };



const centerCursor = async(): Promise<void> => {
    let x: number;
    let y: number;
    const monitor = (JSON.parse(await Hyprland.messageAsync('j/monitors')) as Monitor[])
        .find((m) => m.focused) as Monitor;

    switch (monitor.transform) {
        case 1:
            x = monitor.x - (monitor.height / 2);
            y = monitor.y - (monitor.width / 2);
            break;

        case 2:
            x = monitor.x - (monitor.width / 2);
            y = monitor.y - (monitor.height / 2);
            break;

        case 3:
            x = monitor.x + (monitor.height / 2);
            y = monitor.y + (monitor.width / 2);
            break;

        default:
            x = monitor.x + (monitor.width / 2);
            y = monitor.y + (monitor.height / 2);
            break;
    }

    await Hyprland.messageAsync(`dispatch movecursor ${x} ${y}`);
};

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const makeChild = (class_name: string | Binding<any, any, string>) => {
    const list = ListBox();

    const placeholder = Revealer({
        child: Label({
            label: "   Couldn't find a match",
            class_name: 'placeholder',
        }),
    });

    const entry = Entry({
        // Set some text so on-change works the first time
        text: '-',
        hexpand: true,
    });

    const scrollable = Scrollable({
        hscroll: 'never',
        vscroll: 'automatic',
        child: Box({
            vertical: true,
            children: [list, placeholder],
        }),
    });

    return {
        list,
        entry,
        placeholder,
        scrollable,

        child: Box({
            class_name,
            vertical: true,
            children: [
                Box({
                    class_name: 'header',
                    children: [
                        Icon('preferences-system-search-symbolic'),
                        entry,
                    ],
                }),

                scrollable,
            ],
        }),
    };
};

// eslint-disable-next-line @typescript-eslint/no-unsafe-declaration-merging
export class SortedList<
    Attr,
> extends PopupWindow<MakeChild['child'], Attr> {
    static {
        Widget.register(this, {
            properties: {
            },
        });
    }

    private _list: MakeChild['list'];
    private _entry: MakeChild['entry'];
    private _placeholder: MakeChild['placeholder'];
    private _scrollable: MakeChild['scrollable'];
    private _on_select: (row: ListBoxRow) => void;
    private _init_rows: (list: MakeChild['list']) => void;
    private _on_text_change: (
        text: string,
        list: MakeChild['list'],
        placeholder: MakeChild['placeholder'],
    ) => void;

    set on_open(fun: (self: PopupWindow<MakeChild['child'], Attr>) => void) {
        this._on_open = () => {
            this._entry.text = '';
            fun(this);
            this._init_rows(this._list);
            centerCursor();

            const adjustScroll = this._scrollable.vadjustment;

            this._scrollable.vadjustment.set_value(adjustScroll.lower);
            this._entry.grab_focus();
        };
    }

    constructor({
        on_select = () => { /**/ },
        init_rows = () => { /**/ },
        on_text_change = () => { /**/ },
        setup_list = () => { /**/ },
        on_open = () => { /**/ },
        class_name = '',
        keymode = 'on-demand',
        ...rest
    }: SortedListProps<Attr, PopupWindow<MakeChild['child'], Attr>>) {
        const makeChildResult = makeChild(class_name);

        // PopupWindow
        super({
            child: makeChildResult.child,
            keymode,
            ...rest,
        });

        this.on_open = on_open;

        // SortedList
        this._on_select = on_select;
        this._init_rows = init_rows;
        this._on_text_change = on_text_change;

        this._placeholder = makeChildResult.placeholder;
        this._scrollable = makeChildResult.scrollable;

        this._list = makeChildResult.list;
        this._list.on('row-activated', (_, row) => {
            this._on_select(row);
        });

        this._entry = makeChildResult.entry;

        this._entry.on_change = ({ text }) => {
            if (text !== null || typeof text === 'string') {
                this._on_text_change(text, this._list, this._placeholder);
            }
        };
        // TODO: add on_accept where it just selects the first visible one

        setup_list(this._list, this._entry);
        this._init_rows(this._list);
        this._on_text_change('', this._list, this._placeholder);
    }
}

export default <Attr>(
    props: SortedListProps<Attr, PopupWindow<MakeChild['child'], Attr>>,
) => new SortedList(props);
