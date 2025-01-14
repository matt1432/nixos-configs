import { Variable } from 'astal';
import { Binding } from 'astal/binding';


export const mergeBindings = <Value = unknown>(
    array: (Value | Binding<Value> | Binding<Value[]>)[],
): Value[] | Binding<Value[]> => {
    const getValues = (args: Value[]) => {
        let i = 0;

        return array.map((value) => value instanceof Binding ?
            args[i++] :
            value);
    };

    const bindings = array.filter((i) => i instanceof Binding);

    if (bindings.length === 0) {
        return array as Value[];
    }

    if (bindings.length === 1) {
        return (bindings[0] as Binding<Value[]>).as(getValues);
    }

    return Variable.derive(bindings, getValues)();
};
