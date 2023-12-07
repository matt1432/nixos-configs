import { execAsync, readFileAsync, timeout } from 'resource:///com/github/Aylur/ags/utils.js';
const { get_home_dir } = imports.gi.GLib;

export default ({
    name,
    gobject,
    prop,
    condition = true,
    whenTrue = condition,
    whenFalse = false,
    signal = 'changed',
} = {}) => {
    const cacheFile = `${get_home_dir()}/.cache/ags/.${name}`;

    const stateCmd = () => ['bash', '-c',
        `echo ${gobject[prop] === condition} > ${cacheFile}`];

    const monitorState = () => {
        gobject.connect(signal, () => {
            execAsync(stateCmd()).catch(print);
        });
    };

    readFileAsync(cacheFile)
        .then((content) => {
            // JSON.parse was the only way I found to reliably
            // convert a string of 'true' or 'false' into a bool
            gobject[prop] = JSON.parse(content) ? whenTrue : whenFalse;

            timeout(1000, () => {
                monitorState();
            });
        })
        .catch(() => {
            execAsync(stateCmd())
                .then(() => {
                    monitorState();
                })
                .catch(print);
        });
};
