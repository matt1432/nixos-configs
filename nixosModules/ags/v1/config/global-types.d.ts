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

// For ./ts/on-screen-keyboard
export type OskWindow = Window<BoxGeneric, {
    startY: null | number
    setVisible: (state: boolean) => void
    killGestureSigs: () => void
    setSlideUp: () => void
    setSlideDown: () => void
}>;

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
