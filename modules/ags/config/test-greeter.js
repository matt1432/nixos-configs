// Delete /tmp/ags-greeter before and after using this
import { transpileTypeScript } from './js/utils.js';

export default (await transpileTypeScript('greeter')).default;
