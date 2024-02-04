import 'package:flutter/material.dart';
import 'UploadPdf_Python.dart';
import 'chat_screen.dart';

class MySelectedImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Image Selected')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/medical_report.jpg'),
              ElevatedButton(
                onPressed: () {
                    Navigator.pushNamed(context, '/display-text');
              }, child: Text("Extract Text"),),
            ],
          ),
        ),
      ),
    );
  }
}