import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as imglib;


import 'package:image_picker/image_picker.dart';

class TextViewerPage extends StatefulWidget {
  const TextViewerPage({super.key, required this.title});
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
