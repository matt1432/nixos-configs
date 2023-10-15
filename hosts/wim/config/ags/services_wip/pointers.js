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

/*

      // WIP
      Utils.execAsync('hyprctl layers -j').then(layers => {
        layers = JSON.parse(layers);
        Utils.execAsync('hyprctl cursorpos -j').then(pos => {
          pos = JSON.parse(pos);

          Object.values(layers).forEach(key => {
            key['levels']['3'].forEach(l => {
              print(l.namespace);
              if (pos.x > l.x && pos.x < l.x + l.w &&
                  pos.y > l.y && pos.y < l.y + l.h)
              {
                print('inside window');
              }
              else {
                print('outside window');
              }
            });
          });
        }).catch(print);
      }).catch(print);


*/

// TODO: use hyprctl layers to determine if clicks were on a widget
// read /dev to recalculate devices and remake subprocess

const { Service, Utils } = '../imports.js';


class PointersService extends Service {
  static {
    Service.register(this, {
      'log-started': ['boolean'],
      'device-fetched': ['boolean'],
    });
  }

  log;
  output = "";
  devices = new Map();

  get log() {return this.log;}
  get output() {return this.output;}
  get devices() {return this.devices;}

  parseDevices() {
    Utils.execAsync(['libinput', 'list-devices']).then(out => {
      let lines = out.split('\n');
      let device = null;
      let devices = new Map();

      lines.forEach(line => {
        let parts = line.split(':');

        if (parts[0] === 'Device') {
          device = {};
          devices.set(parts[1].trim(), device);
        }
        else if (device && parts[1]) {
          let key = parts[0].trim();
          let value = parts[1].trim();
          device[key] = value;
        }
      });
      this.devices = devices.filter(dev => dev.Capabilities && dev.Capabilities.includes('pointer'));
      this.emit('device-fetched', true);
    });
  }

  startLog() {
    let args = [];
    this.devices.forEach(dev => {
      if (dev.Kernel) {
        args.push('--device');
        args.push(dev.Kernel);
      }
    });

    this.log = Utils.subprocess(
      ['libinput', 'debug-events', ...args],
      (output) => {
        this.output = output;
      },
      (err) => logError(err)
    );
    this.emit('log-started', true);
  }
}
