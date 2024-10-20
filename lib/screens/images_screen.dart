import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/bluetooth_service.dart';

class ImagesScreen extends StatefulWidget {
  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final ImagePicker _picker = ImagePicker();
  String? imagePath;
  BluetoothServiceHandler? bluetoothService = BluetoothServiceHandler.instance;

  Future<void> selectAndSendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && bluetoothService != null) {
      List<int> imageBytes = await File(image.path).readAsBytes();
      bluetoothService!.sendData(imageBytes);
      setState(() {
        imagePath = image.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagem enviada com sucesso')),
      );
    }
  }

  Future<void> selectAndSendGif() async {
    final XFile? gif = await _picker.pickImage(source: ImageSource.gallery);
    if (gif != null && bluetoothService != null) {
      List<int> gifBytes = await File(gif.path).readAsBytes();
      bluetoothService!.sendData(gifBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('GIF enviado com sucesso')),
      );
    }
  }

  Widget displayImage() {
    if (imagePath != null) {
      return Image.file(
        File(imagePath!),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Text('Nenhuma imagem selecionada');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bluetoothService == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Imagens')),
        body: Center(child: Text('Conecte-se a um dispositivo primeiro')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Imagens')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            displayImage(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectAndSendImage,
              child: Text('Selecionar e Enviar Imagem'),
            ),
            ElevatedButton(
              onPressed: selectAndSendGif,
              child: Text('Selecionar e Enviar GIF'),
            ),
          ],
        ),
      ),
    );
  }
}
