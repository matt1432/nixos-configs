// TODO: persisting data like bluetooth
// TODO: quick-settings
// TODO: music player stuff
// TODO: on-screen-keyboard
// TODO: see if I can bundle each config separately with nix

import { programArgs } from 'system';

import binto from './configurations/binto';
import wim from './configurations/wim';

import greeter from './configurations/greeter';
import lock from './configurations/lock';


switch (programArgs[0]) {
    case 'binto': binto(); break;

    case 'wim': wim(); break;

    case 'greeter': greeter(); break;

    case 'lock': lock(); break;
}
