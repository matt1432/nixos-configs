import { watchAndCompileSass, transpileTypeScript } from 'js/utils';

watchAndCompileSass();
export default (await import(await transpileTypeScript())).default;
