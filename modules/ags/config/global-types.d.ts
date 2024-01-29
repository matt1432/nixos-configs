import { Widget } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';

import { Widget as agsWidget } from 'types/widgets/widget';
export type AgsWidget = agsWidget<unknown> & Widget;

// For ./ts/applauncher/main.ts
import { Application } from 'types/service/applications.ts';
import { CursorBoxProps } from 'ts/misc/cursorbox';
export type AgsAppItem = AgsEventBox<Widget, { app: Application }
& CursorBoxProps<Widget, unknown>>;

// For ./ts/bar/hovers/keyboard.ts
export type Keyboard = {
    address: string;
    name: string;
    rules: string;
    model: string;
    layout: string;
    variant: string;
    options: string;
    active_keymap: string;
    main: boolean;
};

// For ./ts/bar/items/workspaces.ts
// TODO: improve type
export type Workspace = AgsRevealer<unknown & Widget, unknown & { id: number }>;

// For ./ts/bar/fullscreen.ts
export type DefaultProps = RevealerProps<CenterBoxGeneric>;

// For ./ts/media-player/gesture.ts
export type Gesture = {
    attribute?: object
    setup?(self: OverlayGeneric): void
    props?: OverlayProps<unknown & Widget, unknown>
};

// For ./ts/media-player/mpris.ts
type PlayerDragProps = unknown & { dragging: boolean };
export type PlayerDrag = AgsCenterBox<
unknown & Widget, unknown & Widget, unknown & Widget, unknown & PlayerDragProps
>;
type Colors = {
    imageAccent: string;
    buttonAccent: string;
    buttonText: string;
    hoverAccent: string;
};

// For ./ts/media-player
export type PlayerBoxProps = {
    bgStyle: string,
    player: MprisPlayer,
};
export type PlayerBox = AgsCenterBox<
unknown & Widget, unknown & Widget, unknown & Widget, PlayerBoxProps
>;
export type PlayerOverlay = AgsOverlay<AgsWidget, {
    players: Map;
    setup: boolean;
    dragging: boolean;
    includesWidget(playerW: PlayerBox): PlayerBox;
    showTopOnly(): void;
    moveToTop(player: PlayerBox): void;
}>;
export type PlayerButtonType = {
    player: MprisPlayer
    colors: Var<Colors>
    items: Array<[name: string, widget: AgsWidget]>
    onClick: string
    prop: string
};

// For CursorBox
import { CursorBox, CursorBoxProps } from 'ts/misc/cursorbox';
export type CursorBox = CursorBox;
export type CursorBoxProps = CursorBoxProps;

// For PopupWindow
export type PopupChild = Binding<
Var<Widget>,
'is_listening' | 'is_polling' | 'value',
Widget[]
>;
export type CloseType = 'none' | 'stay' | 'released' | 'clicked';
export type PopupWindowProps<Child extends Widget, Attr = unknown> =
WindowProps<Child> & {
    transition?: RevealerProps<Widget>['transition']
    transition_duration?: number
    bezier?: string
    on_open?(self: AgsWindow<Widget, unknown>): void
    on_close?(self: AgsWindow<Widget, unknown>): void
    blur?: boolean
    close_on_unfocus?: CloseType
    attribute?: Attr;
    content?: Widget
    anchor?: Array<'top' | 'bottom' | 'right' | 'left'>;
};
import { PopupWindow } from 'ts/misc/popup';
export type PopupWindow = PopupWindow;


// Generic widgets
import AgsBox from 'types/widgets/box.ts';
export type BoxGeneric = AgsBox<unknown & Widget, unknown>;

import AgsCenterBox, { CenterBoxProps } from 'types/widgets/centerbox';
export type CenterBoxGeneric = AgsCenterBox<
unknown & Widget, unknown & Widget, unknown & Widget, unknown
>;
export type CenterBoxPropsGeneric = CenterBoxProps<
unknown & Widget, unknown & Widget, unknown & Widget, unknown
>;

import AgsEventBox from 'types/widgets/eventbox.ts';
export type EventBoxGeneric = AgsEventBox<unknown & Widget, unknown>;

import AgsLabel from 'types/widgets/label.ts';
export type LabelGeneric = AgsLabel<unknown>;

import AgsOverlay, { OverlayProps } from 'types/widgets/overlay.ts';
export type OverlayGeneric = AgsOverlay<unknown & Widget, unknown>;

import AgsRevealer, { RevealerProps } from 'types/widgets/revealer.ts';
export type RevealerGeneric = AgsRevealer<unknown & Widget, unknown>;

import AgsStack from 'types/widgets/stack.ts';
export type StackGeneric = AgsStack<unknown & Widget, unknown>;
