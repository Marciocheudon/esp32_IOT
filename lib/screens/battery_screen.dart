import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';

class BatteryScreen extends StatefulWidget {
  @override
  _BatteryScreenState createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  double batteryLevel = 0;
  BluetoothServiceHandler? bluetoothService = BluetoothServiceHandler.instance;

  @override
  void initState() {
    super.initState();
    if (bluetoothService != null) {
      bluetoothService!.startListening(onDataReceived);
    }
  }

  void onDataReceived(String data) {
    if (data.startsWith('BATTERY:')) {
      String level = data.split(':')[1];
      setState(() {
        batteryLevel = double.parse(level);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bluetoothService == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Bateria')),
        body: Center(child: Text('Conecte-se a um dispositivo primeiro')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Bateria')),
      body: Center(
        child: Text(
          'Nível da Bateria: ${batteryLevel.toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
