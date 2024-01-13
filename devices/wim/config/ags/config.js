import { watchAndCompileSass, transpileTypeScript } from './js/utils.js';

watchAndCompileSass();
export default (await import(await transpileTypeScript())).default;
