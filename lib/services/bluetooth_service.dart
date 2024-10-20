import 'package:flutter_blue/flutter_blue.dart';

class BluetoothServiceHandler {
  static BluetoothServiceHandler? _instance;
  final BluetoothDevice device;
  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;

  BluetoothServiceHandler._internal({required this.device});

  static BluetoothServiceHandler? get instance => _instance;

  factory BluetoothServiceHandler({required BluetoothDevice device}) {
    _instance ??= BluetoothServiceHandler._internal(device: device);
    return _instance!;
  }

  Future<void> initialize() async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      // Substitua pelos UUIDs do seu serviço e características
      for (BluetoothCharacteristic c in service.characteristics) {
        if (c.properties.write) {
          _writeCharacteristic = c;
        }
        if (c.properties.notify) {
          _notifyCharacteristic = c;
          await c.setNotifyValue(true);
        }
      }
    }
  }

  void startListening(Function(String) onDataReceived) {
    if (_notifyCharacteristic != null) {
      _notifyCharacteristic!.value.listen((value) {
        String data = String.fromCharCodes(value);
        onDataReceived(data);
      });
    }
  }

  void sendData(List<int> data) async {
    if (_writeCharacteristic != null) {
      int mtu = await device.mtu.first;
      int chunkSize = mtu - 3;
      for (int offset = 0; offset < data.length; offset += chunkSize) {
        int end = (offset + chunkSize > data.length)
            ? data.length
            : offset + chunkSize;
        await _writeCharacteristic!.write(
          data.sublist(offset, end),
          withoutResponse: true,
        );
      }
    }
  }

  void dispose() {
    device.disconnect();
    _instance = null;
  }
}
