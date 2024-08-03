import { Widget } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import GObject from 'types/@girs/gobject-2.0/gobject-2.0';

import { Variable as Var } from 'types/variable';
import { Widget as agsWidget } from 'types/widgets/widget';
export type AgsWidget = agsWidget<unknown> & Widget;

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

import AgsEventBox from 'types/widgets/eventbox';
export type EventBoxGeneric = AgsEventBox<unknown & Widget, unknown>;

import AgsIcon, { IconProps } from 'types/widgets/icon';
export type IconGeneric = AgsIcon<unknown>;
export type IconPropsGeneric = IconProps<unknown>;

import AgsLabel from 'types/widgets/label';
export type LabelGeneric = AgsLabel<unknown>;

import AgsOverlay, { OverlayProps } from 'types/widgets/overlay';
export type OverlayGeneric = AgsOverlay<unknown & Widget, unknown>;

import AgsProgressBar from 'types/widgets/progressbar';
export type ProgressBarGeneric = AgsProgressBar<unknown & Widget, unknown>;

import AgsRevealer, { RevealerProps } from 'types/widgets/revealer';
export type RevealerGeneric = AgsRevealer<unknown & Widget, unknown>;

import AgsStack, { StackProps } from 'types/widgets/stack';
export type StackGeneric = AgsStack<Record<string, Widget>, unknown>;

import AgsScrollable from 'types/widgets/scrollable';
export type ScrollableGeneric = AgsScrollable<unkown & Widget, unknown>;

import AgsWindow from 'types/widgets/window';
export type WindowGeneric = AgsWindow<unknown & Widget, unknown>;


// For ./ts/applauncher/main.ts
import { Application } from 'types/service/applications.ts';
import { CursorBoxProps } from 'ts/misc/cursorbox';
export type AgsAppItem = AgsEventBox<Widget, { app: Application }
  & CursorBoxProps<Widget, unknown>>;

// For ./ts/bar/hovers/keyboard.ts
export interface Keyboard {
    address: string
    name: string
    rules: string
    model: string
    layout: string
    variant: string
    options: string
    active_keymap: string
    main: boolean
}

// For ./ts/bar/items/workspaces.ts
// TODO: improve type
export type Workspace = AgsRevealer<unknown & Widget, unknown & { id: number }>;

// For ./ts/bar/fullscreen.ts
export type DefaultProps = RevealerProps<CenterBoxGeneric>;

// For ./ts/media-player/gesture.ts
export interface Gesture {
    attribute?: object
    setup?(self: OverlayGeneric): void
    props?: OverlayProps<unknown & Widget, unknown>
}

// For ./ts/media-player/mpris.ts
type PlayerDragProps = unknown & { dragging: boolean };
export type PlayerDrag = AgsCenterBox<
unknown & Widget, unknown & Widget, unknown & Widget, unknown & PlayerDragProps
>;
interface Colors {
    imageAccent: string
    buttonAccent: string
    buttonText: string
    hoverAccent: string
}

// For ./ts/media-player
export interface PlayerBoxProps {
    bgStyle: string
    player: MprisPlayer
}
export type PlayerBox = AgsCenterBox<
unknown & Widget, unknown & Widget, unknown & Widget, PlayerBoxProps
>;
export type PlayerOverlay = AgsOverlay<AgsWidget, {
    players: Map
    setup: boolean
    dragging: boolean
    includesWidget(playerW: PlayerBox): PlayerBox
    showTopOnly(): void
    moveToTop(player: PlayerBox): void
}>;
export interface PlayerButtonType {
    player: MprisPlayer
    colors: Var<Colors>
    children: StackProps['children']
    onClick: string
    prop: string
}

// For ./ts/notifications/gesture.js
interface NotifGestureProps {
    dragging: boolean
    hovered: boolean
    ready: boolean
    id: number
    slideAway(side: 'Left' | 'Right'): void
}
export type NotifGesture = AgsEventBox<BoxGeneric, NotifGestureProps>;

// For ./ts/osd/ctor.ts
export type OSDStack = AgsStack<unknown & Widget, {
    popup(osd: string): void
}>;
export type ConnectFunc = (self?: ProgressBarGeneric) => void;
export interface OSD {
    name: string
    icon: IconPropsGeneric['icon']
    info: {
        mod: GObject.Object
        signal?: string | string[]
        logic?(self: ProgressBarGeneric): void
        widget?: AgsWidget
    }
}

// For ./ts/on-screen-keyboard
export type OskWindow = Window<BoxGeneric, {
    startY: null | number
    setVisible: (state: boolean) => void
    killGestureSigs: () => void
    setSlideUp: () => void
    setSlideDown: () => void
}>;

// For CursorBox
import { CursorBox, CursorBoxProps } from 'ts/misc/cursorbox';
export type CursorBox = CursorBox;
export type CursorBoxProps = CursorBoxProps;

// For PopupWindow
export type HyprTransition = 'slide' | 'slide top' | 'slide bottom' | 'slide left' |
  'slide right' | 'popin' | 'fade';
export type CloseType = 'none' | 'stay' | 'released' | 'clicked';
import { PopupWindow } from 'ts/misc/popup';
export type PopupWindow = PopupWindow;

// For ./ts/quick-settings
import { BluetoothDevice as BTDev } from 'types/service/bluetooth.ts';
export interface APType {
    bssid: string
    address: string
    lastSeen: number
    ssid: string
    active: boolean
    strength: number
    iconName: string
}
export type APBox = AgsBox<unknown & Widget, { ap: Var<APType> }>;
export type DeviceBox = AgsBox<unknown & Widget, { dev: BTDev }>;
