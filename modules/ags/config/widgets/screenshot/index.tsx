import { Astal, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';
import AstalApps from 'gi://AstalApps';
import AstalHyprland from 'gi://AstalHyprland';
import { createBinding, createState, For } from 'gnim';

import { getWindow, hyprMessage } from '../../lib';
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

    const windowList = (<box vertical />) as Astal.Box;

    const updateWindows = async () => {
        if (!getWindow('win-screenshot')?.get_visible()) {
            return;
        }

        const applications = AstalApps.Apps.new();

        windowList.children = (
            JSON.parse(await hyprMessage('j/clients')) as AstalHyprland.Client[]
        )
            .filter(
                (client) =>
                    client.workspace.id ===
                    hyprland.get_focused_workspace().get_id(),
            )
            .map(
                (client) =>
                    (
                        <cursor-button
                            class="item-btn"
                            cursor="pointer"
                            onButtonReleaseEvent={() => {
                                takeScreenshot(['-w', client.address]);
                            }}
                        >
                            <box halign={Gtk.Align.CENTER}>
                                <icon
                                    icon={
                                        applications.fuzzy_query(
                                            client.class,
                                        )[0].iconName
                                    }
                                />

                                <Separator size={ICON_SEP} />

                                <label
                                    label={client.title}
                                    truncate
                                    max_width_chars={50}
                                />
                            </box>
                        </cursor-button>
                    ) as Astal.Button,
            );
    };

    hyprland.connect('notify::clients', updateWindows);
    hyprland.connect('notify::focused-workspace', updateWindows);

    const [shown, setShown] = createState('monitors');

    const stackContent = [
        <scrollable $type="named" name="monitors">
            <box vertical>
                <For each={createBinding(hyprland, 'monitors')}>
                    {(monitor: AstalHyprland.Monitor) => (
                        <cursor-button
                            class="item-btn"
                            cursor="pointer"
                            onButtonReleaseEvent={() => {
                                takeScreenshot(['-o', monitor.get_name()]);
                            }}
                        >
                            <label
                                label={`${monitor.get_name()}: ${monitor.get_description()}`}
                                truncate
                                maxWidthChars={50}
                            />
                        </cursor-button>
                    )}
                </For>
            </box>
        </scrollable>,

        <scrollable $type="named" name="windows">
            {windowList}
        </scrollable>,
    ] as Gtk.Widget[];

    const stack = (
        <stack
            visibleChildName={shown}
            transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
        >
            {stackContent}
        </stack>
    ) as Astal.Stack;

    const StackButton = ({ label = '', iconName = '' }) =>
        (
            <cursor-button
                cursor="pointer"
                class={shown.as(
                    (shown) => `header-btn${shown === label ? ' active' : ''}`,
                )}
                onButtonReleaseEvent={() => {
                    setShown(label);
                }}
            >
                <box halign={Gtk.Align.CENTER}>
                    <icon icon={iconName} />

                    <Separator size={ICON_SEP} />

                    {label}
                </box>
            </cursor-button>
        ) as Astal.Button;

    let frozen = false;
    const freezeIcon = (<icon icon="checkbox-symbolic" />) as Astal.Icon;
    const freezeButton = (
        <cursor-button
            cursor="pointer"
            class="header-btn"
            onButtonReleaseEvent={() => {
                frozen = !frozen;
                freezeIcon.set_icon(
                    frozen ? 'checkbox-checked-symbolic' : 'checkbox-symbolic',
                );
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                {freezeIcon}
                <Separator size={ICON_SEP} />
                freeze
            </box>
        </cursor-button>
    ) as Astal.Button;

    const regionButton = (
        <cursor-button
            cursor="pointer"
            class="header-btn"
            onButtonReleaseEvent={() => {
                takeScreenshot(['region', frozen ? 'true' : 'false'], 0);
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <icon icon="tool-crop-symbolic" />
            </box>
        </cursor-button>
    ) as Astal.Button;

    return (
        <PopupWindow
            name="screenshot"
            openCallback={() => {
                updateWindows();
            }}
        >
            <box class="screenshot widget" vertical>
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
