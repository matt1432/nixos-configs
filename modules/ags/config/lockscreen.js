import { transpileTypeScript } from './js/utils.js';

export default (await transpileTypeScript('lockscreen')).default;
