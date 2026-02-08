import { execAsync, GLib, readFileAsync, timeout, type Variable } from 'astal';

const { get_home_dir } = GLib;

export default <T>({
    name,
    variable,
    condition = true,
    whenTrue = condition,
    whenFalse = false,
}: {
    name: string;
    variable: Variable<T>;
    condition?: boolean | string;
    whenTrue?: boolean | string;
    whenFalse?: boolean | string;
}) => {
    const cacheFile = `${get_home_dir()}/.cache/ags/.${name}`;

    const stateCmd = () => [
        'bash',
        '-c',
        `echo ${variable.get() === condition} > ${cacheFile}`,
    ];

    const monitorState = () => {
        variable.subscribe(() => {
            execAsync(stateCmd()).catch(print);
        });
    };

    readFileAsync(cacheFile)
        .then((content) => {
            // JSON.parse was the only way I found to reliably
            // convert a string of 'true' or 'false' into a bool
            const value = (JSON.parse(content) ? whenTrue : whenFalse) as T;

            variable.set(value);

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
