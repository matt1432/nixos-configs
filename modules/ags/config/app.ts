import './widgets/misc/icon';
import { programArgs } from 'system';

import binto from './configurations/binto';
import greeter from './configurations/greeter';
import lock from './configurations/lock';
import wim from './configurations/wim';

switch (programArgs[0]) {
    case 'binto':
        binto();
        break;

    case 'wim':
        wim();
        break;

    case 'greeter':
        greeter();
        break;

    case 'lock':
        lock();
        break;
}
