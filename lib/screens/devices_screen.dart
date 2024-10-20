import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../services/bluetooth_service.dart';

class DevicesScreen extends StatefulWidget {
  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothServiceHandler? bluetoothService;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!devicesList.contains(r.device)) {
          setState(() {
            devicesList.add(r.device);
          });
        }
      }
    });

    flutterBlue.stopScan();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    bluetoothService = BluetoothServiceHandler(device: device);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Conectado a ${device.name}')),
    );
  }

  Widget buildDeviceList() {
    return ListView.builder(
      itemCount: devicesList.length,
      itemBuilder: (context, index) {
        BluetoothDevice device = devicesList[index];
        return ListTile(
          title:
              Text(device.name.isEmpty ? 'Dispositivo sem nome' : device.name),
          subtitle: Text(device.id.toString()),
          onTap: () => connectToDevice(device),
        );
      },
    );
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispositivos Bluetooth'),
      ),
      body: devicesList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : buildDeviceList(),
    );
  }
}
