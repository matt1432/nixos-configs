const { Icon, Label } = Widget;

import Brightness from '../../../services/brightness.ts';
import HoverRevealer from './hover-revealer.ts';


export default () => HoverRevealer({
    class_name: 'brightness',

    icon: Icon({
        icon: Brightness.bind('screenIcon'),
    }),

    label: Label().hook(Brightness, (self) => {
        self.label = `${Math.round(Brightness.screen * 100)}%`;
    }, 'screen'),
});
