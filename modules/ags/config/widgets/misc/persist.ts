import { readFileAsync } from 'ags/file';
import { execAsync } from 'ags/process';
import { timeout } from 'ags/time';
import GLib from 'gi://GLib';
import { Accessor, Setter } from 'gnim';

const { get_home_dir } = GLib;

export default <T>({
    name,
    variableGetter,
    variableSetter,
    condition = true,
    whenTrue = condition,
    whenFalse = false,
}: {
    name: string;
    variableGetter: Accessor<T>;
    variableSetter: Setter<T>;
    condition?: boolean | string;
    whenTrue?: boolean | string;
    whenFalse?: boolean | string;
}) => {
    const cacheFile = `${get_home_dir()}/.cache/ags/.${name}`;

    const stateCmd = () => [
        'bash',
        '-c',
        `echo ${variableGetter() === condition} > ${cacheFile}`,
    ];

    const monitorState = () => {
        variableGetter.subscribe(() => {
            execAsync(stateCmd()).catch(print);
        });
    };

    readFileAsync(cacheFile)
        .then((content) => {
            // JSON.parse was the only way I found to reliably
            // convert a string of 'true' or 'false' into a bool
            const value = (JSON.parse(content) ? whenTrue : whenFalse) as T;

            variableSetter(value);

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
