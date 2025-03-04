import { bind, Variable } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';

import AstalWp from 'gi://AstalWp';

import Separator from '../misc/separator';

import Streams from './streams';
import Profiles from './profiles';


export default () => {
    const audio = AstalWp.get_default()?.get_audio();

    if (!audio) {
        throw new Error('Could not find default audio devices.');
    }

    const Shown = Variable<string>('outputs');

    const stack = (
        <stack
            shown={bind(Shown)}
            transitionType={Gtk.StackTransitionType.SLIDE_LEFT_RIGHT}
        >

            <scrollable
                name="outputs"
                hscroll={Gtk.PolicyType.NEVER}

                setup={(self) => setTimeout(() => {
                    self.add((
                        <box vertical>
                            {bind(audio, 'speakers').as(Streams)}
                        </box>
                    ));
                }, 1000)}
            />

            <scrollable
                name="inputs"
                hscroll={Gtk.PolicyType.NEVER}

                setup={(self) => setTimeout(() => {
                    self.add((
                        <box vertical>
                            {bind(audio, 'microphones').as(Streams)}
                        </box>
                    ));
                }, 1000)}
            />

            <scrollable
                name="profiles"
                hscroll={Gtk.PolicyType.NEVER}

                setup={(self) => setTimeout(() => {
                    self.add((
                        <box vertical>
                            {bind(audio, 'devices').as(Profiles)}
                        </box>
                    ));
                }, 1000)}
            />

        </stack>
    ) as Widget.Stack;

    const StackButton = ({ label = '', iconName = '' }) => (
        <button
            cursor="pointer"
            className={bind(Shown).as((shown) =>
                `header-btn${shown === label ? ' active' : ''}`)}

            onButtonReleaseEvent={() => {
                Shown.set(label);
            }}
        >
            <box halign={Gtk.Align.CENTER}>
                <icon icon={iconName} />

                <Separator size={8} />

                {label}
            </box>
        </button>
    ) as Widget.Button;

    return (
        <box
            className="audio widget"
            vertical
        >
            <box
                className="header"
                homogeneous
            >
                <StackButton label="outputs" iconName="audio-speakers-symbolic" />
                <StackButton label="inputs" iconName="audio-input-microphone-symbolic" />
                <StackButton label="profiles" iconName="application-default-symbolic" />
            </box>

            {stack}
        </box>
    );
};
