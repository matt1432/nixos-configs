import { programArgs } from 'system';

import binto from './configurations/binto';
import wim from './configurations/wim';

import greeter from './configurations/greeter';


switch (programArgs[0]) {
    case 'binto': binto(); break;

    case 'wim': wim(); break;

    case 'greeter': greeter(); break;
}
