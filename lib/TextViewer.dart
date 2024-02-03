import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;


import 'package:image_picker/image_picker.dart';

class TextViewerPage extends StatefulWidget {
  const TextViewerPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TextViewerPage> createState() => TextViewerPageState();
}

class TextViewerPageState extends State<TextViewerPage> {
  late final XFile? _xFile; 
  String _text = "";
  final InputImageFormat nv21 = InputImageFormat.nv21;


  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final String extractedBase64String = arguments['text'];

    Future<void> decodeTextToXFile () async {
      Uint8List bytes = base64Decode(extractedBase64String);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      File imageFile = new File ('$tempPath/' + 'image.png');
      imageFile.writeAsBytesSync(bytes);
      
      final imglib.Image? image = imglib.decodeImage(await imageFile.readAsBytes());
      final Uint8List imageBytes = await imageFile.readAsBytes(); // fix below error
      final InputImageData inputImageData = InputImageData (
        size: Size(image!.width.toDouble(), image.height.toDouble()),
        imageRotation: InputImageRotation.rotation0deg,
        inputImageFormat: nv21,
        planeData: [
          InputImagePlaneMetadata(
            bytesPerRow: 2,
            height: image.height,
            width: image.width
          )
        ],
      );
      final InputImage inputImage = InputImage.fromBytes(bytes: imageBytes, inputImageData: inputImageData);

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      Navigator.pushNamed(context, '/parsed-text', arguments: {'text': recognizedText.text});
      textRecognizer.close();
    }


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector (
              onTap: () {
                Navigator.pushNamed (context, '/upload-pdf', arguments: {'text': _xFile});
              }
            ),
            Text(
              '$_text',
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      ), 
    );
  }
}
