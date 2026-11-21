import { Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';
import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';
import Pango from 'gi://Pango';
import { createBinding, createState, For } from 'gnim';

import { getWindow, hyprMessage } from '../../lib';
import { getChildren, pointer } from '../../lib/widgets';
import PopupWindow from '../misc/popup-window';
import Separator from '../misc/separator';

const ICON_SEP = 6;
const takeScreenshot = (selector: string[], delay = 1000): void => {
    getWindow('win-screenshot')?.set_visible(false);

    setTimeout(() => {
        execAsync(
            [`${SRC}/widgets/screenshot/capture.sh`].concat(selector),
        ).catch(console.error);
    }, delay);
};

export default () => {
    const hyprland = AstalHyprland.get_default();

    const windowList = (
        <box orientation={Gtk.Orientation.VERTICAL} />
    ) as Gtk.Box;

    const updateWindows = async () => {
        if (!getWindow('win-screenshot')?.get_visible()) {
            return;
        }

        const applications = AstalApps.Apps.new();
        const currentWS = JSON.parse(
            await hyprMessage('j/activeworkspace'),
        ).address;

        const clients = (
            JSON.parse(await hyprMessage('j/clients')) as AstalHyprland.Client[]
        ).filter((client) => client.workspace.id === currentWS);

        getChildren(windowList).forEach((child) => {
            windowList.remove(child);
        });

        clients.forEach((client) => {
            windowList.append(
                (
                    <button
                        class="item-btn"
                        cursor={pointer}
                        onClicked={() => {
                            takeScreenshot(['-w', client.address]);
                        }}
                    >
                        <box halign={Gtk.Align.CENTER}>
                            <image
                                iconName={
                                    applications.fuzzy_query(client.class)[0]
                                        ?.iconName ?? ''
                                }
                            />

                            <Separator size={ICON_SEP} />

                            <label
                                label={client.title}
                                ellipsize={Pango.EllipsizeMode.END}
                                maxWidthChars={50}
                            />
                        </box>
                    </button>
                ) as Gtk.Button,
            );
        });
    };

    hyprland.connect('notify::clients', updateWindows);
    hyprland.connect('notify::focused-workspace', updateWindows);

    const [shown, setShown] = createState<string | undefined>(undefined);

    const stackContent = [
        <scrolledwindow $type="named" name="monitors">
            <box
                $={() => {
                    setShown('monitors');
                }}
                orientation={Gtk.Orientation.VERTICAL}
            >
                <For each={createBinding(hyprland, 'monitors')}>
                    {(monitor: AstalHyprland.Monitor) => (
                        <button
                            class="item-btn"
                            cursor={pointer}
                            onClicked={() => {
                                takeScreenshot(['-o', monitor.get_name()]);
                            }}
                        >
                            <label
                                label={`${monitor.get_name()}: ${monitor.get_description()}`}
                                ellipsize={Pango.EllipsizeMode.END}
                                maxWidthChars={50}
                            />
                        </button>
                    )}
                </For>
            </box>
        </scrolledwindow>,

        <scrolledwindow $type="named" name="windows">
            {windowList}
        </scrolledwindow>,
    ] as Gtk.Widget[];

    const stack = (
        <stack transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}>
            {stackContent}
        </stack>
    ) as Gtk.Stack;

    const StackButton = ({ label = '', iconName = '' }) =>
        (
            <button
                cursor={pointer}
                class={shown.as(
                    (s) => `header-btn${s === label ? ' active' : ''}`,
                )}
                onClicked={() => {
                    setShown(label);
                }}
            >
                <box halign={Gtk.Align.CENTER}>
                    <image iconName={iconName} />

                    <Separator size={ICON_SEP} />

                    {label}
                </box>
            </button>
        ) as Gtk.Button;

    const [frozen, setFrozen] = createState(false);

    const freezeButton = (
        <button
            cursor={pointer}
            class="header-btn"
            onClicked={() => {
                setFrozen(!frozen());
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <image
                    iconName={frozen.as((f) =>
                        f ? 'checkbox-checked-symbolic' : 'checkbox-symbolic',
                    )}
                />
                <Separator size={ICON_SEP} />
                freeze
            </box>
        </button>
    ) as Gtk.Button;

    const regionButton = (
        <button
            cursor={pointer}
            class="header-btn"
            onClicked={() => {
                takeScreenshot(['region', frozen() ? 'true' : 'false'], 0);
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <image iconName="tool-crop-symbolic" />
            </box>
        </button>
    ) as Gtk.Button;

    shown.subscribe(() => {
        const label = shown();
        if (typeof label !== 'undefined') {
            stack.set_visible_child_name(label);
        }
    });

    return (
        <PopupWindow
            name="screenshot"
            open_callback={() => {
                updateWindows();
            }}
        >
            <box
                class="screenshot widget"
                orientation={Gtk.Orientation.VERTICAL}
            >
                <box class="header" homogeneous>
                    <StackButton label="monitors" iconName="display-symbolic" />
                    <StackButton label="windows" iconName="window-symbolic" />
                    <box>
                        {regionButton}
                        {freezeButton}
                    </box>
                </box>

                {stack}
            </box>
        </PopupWindow>
    );
};
