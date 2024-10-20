import 'package:flutter/material.dart';
import 'devices_screen.dart';
import 'images_screen.dart';
import 'battery_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controlador do Gadget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HomeButton(
              title: 'Dispositivos',
              icon: Icons.bluetooth,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DevicesScreen()),
                );
              },
            ),
            HomeButton(
              title: 'Imagens',
              icon: Icons.image,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImagesScreen()),
                );
              },
            ),
            HomeButton(
              title: 'Bateria',
              icon: Icons.battery_full,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BatteryScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  HomeButton(
      {required this.title, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 40),
        label: Text(
          title,
          style: TextStyle(fontSize: 24),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 80),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
