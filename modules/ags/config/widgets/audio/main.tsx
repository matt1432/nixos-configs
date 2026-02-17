import { Astal, Gtk } from 'ags/gtk3';
import AstalWp from 'gi://AstalWp';
import { createBinding, createState } from 'gnim';

import Separator from '../misc/separator';
import Profiles from './profiles';
import Streams from './streams';

export default () => {
    const audio = AstalWp.get_default()?.get_audio();

    if (!audio) {
        throw new Error('Could not find default audio devices.');
    }

    const [shown, setShown] = createState('outputs');

    const content = [
        <scrollable $type="named" name="outputs" hscroll={Gtk.PolicyType.NEVER}>
            <box vertical>{Streams(createBinding(audio, 'speakers'))}</box>
        </scrollable>,

        <scrollable $type="named" name="inputs" hscroll={Gtk.PolicyType.NEVER}>
            <box vertical>{Streams(createBinding(audio, 'microphones'))}</box>
        </scrollable>,

        <scrollable
            $type="named"
            name="profiles"
            hscroll={Gtk.PolicyType.NEVER}
        >
            <box vertical>{Profiles(createBinding(audio, 'devices'))}</box>
        </scrollable>,
    ] as Gtk.Widget[];

    const stack = (
        <stack
            visibleChildName={shown}
            transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
        >
            {content}
        </stack>
    ) as Astal.Stack;

    const StackButton = ({ label = '', iconName = '' }) => {
        return (
            <cursor-button
                cursor="pointer"
                class={shown(
                    (s) => `header-btn${s === label ? ' active' : ''}`,
                )}
                onButtonReleaseEvent={() => {
                    setShown(label);
                }}
            >
                <box halign={Gtk.Align.CENTER}>
                    <icon icon={iconName} />

                    <Separator size={8} />

                    {label}
                </box>
            </cursor-button>
        ) as Astal.Button;
    };

    return (
        <box class="audio widget" vertical>
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
                    label="profiles"
                    iconName="application-default-symbolic"
                />
            </box>

            {stack}
        </box>
    );
};
