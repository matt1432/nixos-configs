import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import Tablet from '../services/tablet.js';
import Pointers from '../services/pointers.js';
import closeAll from './misc/closer.js';


export default () => {
    globalThis.Tablet = Tablet;
    globalThis.Pointers = Pointers;
    globalThis.closeAll = closeAll;

    execAsync(['bash', '-c', '$AGS_PATH/startup.sh']).catch(print);
};
