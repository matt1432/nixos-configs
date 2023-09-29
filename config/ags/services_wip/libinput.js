/*
import Libinput from './libinput.js';
Libinput.instance.connect('device-init', () => {
  let pointers = [];
  Libinput.devices.forEach(dev => {
    if (dev.Capabilities.includes('pointer')) {
      pointers.push(dev);
    }
  })
  Libinput.addDebugInstance('pointers', pointers)
    .connect('new-line', e => print(e.lastLine))
});
*/

const { Service } = ags;
const { execAsync } = ags.Utils;
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
import GObject from 'gi://GObject';

class DebugInstance extends GObject.Object {
  static {
    GObject.registerClass({
      Signals: {
        'changed': {},
        'closed': {},
        'new-line': {},
      },
    }, this);
  }
  devices = [];
  name = '';
  lastLine = '';

  readOutput(stdout, stdin) {
    stdout.read_line_async(GLib.PRIORITY_LOW, null, (stream, result) => {
      try {
        const [line] = stream.read_line_finish_utf8(result);

        if (line !== null) {
          this.lastLine = line;
          this.emit('new-line');
          this.readOutput(stdout, stdin);
        }
      } catch (e) {
        logError(e);
      }
    });
  }

  getOutput(devs) {
    try {
      let args = [];
      devs.forEach(dev => {
        if (dev.Kernel) {
          args.push('--device');
          args.push(dev.Kernel);
        }
      });

      const proc = Gio.Subprocess.new(['libinput', 'debug-events', ...args],
        Gio.SubprocessFlags.STDIN_PIPE | Gio.SubprocessFlags.STDOUT_PIPE);

      // Get the `stdin`and `stdout` pipes, wrapping `stdout` to make it easier to
      // read lines of text
      const stdinStream = proc.get_stdin_pipe();
      const stdoutStream = new Gio.DataInputStream({
        base_stream: proc.get_stdout_pipe(),
        close_base_stream: true,
      });

      // Start the loop
     this.readOutput(stdoutStream, stdinStream);
    } catch (e) {
      logError(e);
    }
  }

  constructor(name, devs) {
    super();

    this.devices = devs;
    this.name = name;

    this.getOutput(devs);
  }
}

class LibinputService extends Service {
  static {
    Service.register(this, {
      'device-init': ['boolean'],
      'instance-closed': ['string'],
      'instance-added': ['string'],
    });
  }

  debugInstances = new Map();
  devices = new Map();

  get devices() { return this._devices; }

  parseOutput(output) {
    let lines = output.split('\n');
    let device = null;

    lines.forEach(line => {
      let parts = line.split(':');

      if (parts[0] === 'Device') {
        device = {};
        this.devices.set(parts[1].trim(), device);
      }
      else if (device && parts[1]) {
        let key = parts[0].trim();
        let value = parts[1].trim();
        device[key] = value;
      }
    });
    this.emit('device-init', true);
  }

  constructor() {
    super();
    this.debugInstances = new Map();
    execAsync(['libinput', 'list-devices'])
      .then(out => this.parseOutput(out))
      .catch(console.error);
  }

  addDebugInstance(name, devs) {
    if (this.debugInstances.get(name))
      return;

    devs = Array(devs);
    if (devs.some(dev => dev.Capabilities && dev.Capabilities.includes('pointer'))) {
    }
    const debugInst = new DebugInstance(name, devs);

    debugInst.connect('closed', () => {
      this.debugInstances.delete(name);
      this.emit('instance-closed', name);
      this.emit('changed');
    });

    this.debugInstances.set(name, debugInst);
    this.emit('instance-added', name);
    return debugInst;
  }
}

export default class Libinput {
  static { Service.Libinput = this; }
  static instance = new LibinputService();

  static get devices() { return Libinput.instance.devices; }
  static get debugInstances() { return Libinput.instance.debugInstances; }

  static addDebugInstance(name, dev) {
    return Libinput.instance.addDebugInstance(name, dev);
  }
}
