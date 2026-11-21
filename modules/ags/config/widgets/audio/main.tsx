import { Gtk } from 'ags/gtk4';
import AstalWp from 'gi://AstalWp';
import { createBinding, createState } from 'gnim';

import { pointer } from '../../lib/widgets';
import Separator from '../misc/separator';
import Endpoints from './endpoints';
import Profiles from './profiles';
import Streams from './streams';

export default () => {
    const audio = AstalWp.get_default()?.get_audio();

    if (!audio) {
        throw new Error('Could not find default audio devices.');
    }

    const [shown, setShown] = createState<string | undefined>(undefined);

    const content = [
        <scrolledwindow
            $type="named"
            name="outputs"
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
        >
            <box
                $={() => {
                    setShown('outputs');
                }}
                orientation={Gtk.Orientation.VERTICAL}
            >
                {Endpoints(createBinding(audio, 'speakers').as((v) => v || []))}
            </box>
        </scrolledwindow>,

        <scrolledwindow
            $type="named"
            name="inputs"
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
        >
            <box orientation={Gtk.Orientation.VERTICAL}>
                {Endpoints(
                    createBinding(audio, 'microphones').as((v) => v || []),
                )}
            </box>
        </scrolledwindow>,

        <scrolledwindow
            $type="named"
            name="apps"
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
        >
            <box orientation={Gtk.Orientation.VERTICAL}>
                {Streams(
                    createBinding(audio, 'streams').as((v) => v || []),
                    shown.as((s) => s === 'apps'),
                )}
            </box>
        </scrolledwindow>,

        <scrolledwindow
            $type="named"
            name="profiles"
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
        >
            <box orientation={Gtk.Orientation.VERTICAL}>
                {Profiles(createBinding(audio, 'devices').as((v) => v || []))}
            </box>
        </scrolledwindow>,
    ] as Gtk.Widget[];

    const stack = (
        <stack transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}>
            {content}
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

                    <Separator size={8} />

                    {label}
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
        <box class="audio widget" orientation={Gtk.Orientation.VERTICAL}>
            <box class="header" homogeneous>
                <StackButton
                    label="outputs"
                    iconName="audio-speakers-symbolic"
                />
                <StackButton
                    label="inputs"
                    iconName="audio-input-microphone-symbolic"
                />
                <StackButton
                    label="apps"
                    iconName="multimedia-volume-control-symbolic"
                />
                <StackButton
                    label="profiles"
                    iconName="application-default-symbolic"
                />
            </box>

            {stack}
        </box>
    );
};
