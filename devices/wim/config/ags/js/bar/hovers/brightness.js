import { Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../../services/brightness.js';
import HoverRevealer from './hover-revealer.js';


export default () => HoverRevealer({
    class_name: 'brightness',

    icon: Icon({
        icon: Brightness.bind('screenIcon'),
    }),

    label: Label().hook(Brightness, (self) => {
        self.label = `${Math.round(Brightness.screen * 100)}%`;
    }, 'screen'),
});
