import { programArgs } from 'system';

import lock from './configurations/lock';


switch (programArgs[0]) {
    case 'lock': lock(); break;
}
