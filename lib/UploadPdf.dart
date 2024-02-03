import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as imglib;
import 'package:med_education_platform/modal_dialog.dart';
import 'package:med_education_platform/recognization_page.dart';
import 'package:med_education_platform/Utils/image_cropper_page.dart';
import 'package:med_education_platform/Utils/image_picker_class.dart';
import 'package:flutter/services.dart';

class UploadPdfPage extends StatefulWidget {
  @override
  UploadPdfPageState createState() => UploadPdfPageState();
}

class UploadPdfPageState extends State<UploadPdfPage> {
  late FilePickerResult _pickedFile;
  late XFile _xFile;
  final ImagePicker _picker = ImagePicker();
  String _state = "";
  String _uploadImagestate = "";

  final InputImageFormat nv21 = InputImageFormat.nv21;

  Future<void> _pickPdf() async {
    _pickedFile = (await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ))!;
  }


  Future<void> _uploadPdf() async {
    final String apiUrl = 'http://127.0.0.1:5000/upload-pdf';

    try {
      // Read the PDF file as bytes
      List<int> pdfBytes = _pickedFile.files.first.bytes as List<int>;
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      // Attach the PDF file to the request
      request.files.add(http.MultipartFile.fromBytes('file', pdfBytes, filename: _pickedFile.files.first.name));
      // Send the request
      final response = await request.send();
      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the JSON response
        // final Map<String, dynamic> data = json.decode(await response.stream.bytesToString());

        // // Do something with the data
        // print('API Response: $data');
        setState(() {
          // Change the text when the button is pressed
          _state = "File has been successfully uploaded";
        });
      } else {
        // If the server did not return a 200 OK response,
        // handle the error accordingly
        setState(() {
          // Change the text when the button is pressed
          _state = "Error has occurred. File hasn't been successfully uploaded";
        });
      }
      print(_state);
    } catch (error) {
      // Handle exceptions such as network errors
      print('Error: $error');
    }
  }

  Future<void> _uploadImage() async {

    // final String apiUrl = 'http://127.0.0.1:5000/upload-pdf';\

    late double _imageHeight;
    late double _imageWidth;
    XFile _xFile;
    try {
      // Read the image file as bytes
      _pickedFile = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png',],
    ))!;

    //file picker result to file
    final File convertedFile = File(_pickedFile.files.single.path!);
    final decodedImage = await decodeImageFromList(await convertedFile.readAsBytes());
    setState(() {
    _imageHeight = decodedImage.height.toDouble();
    _imageWidth = decodedImage.width.toDouble();
    });
    final Uint8List imageBytes = convertedFile.readAsBytesSync();
    final InputImageData inputImageData = InputImageData (
      size: Size(_imageWidth, _imageHeight),
      imageRotation: InputImageRotation.rotation0deg,
      inputImageFormat: nv21,
      planeData: [
        InputImagePlaneMetadata(
          bytesPerRow: 2,
          height: 2,
          width: 2
        )
      ],
    );
      final InputImage inputImage = InputImage.fromBytes(bytes: imageBytes, inputImageData: inputImageData);

      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);


    } catch (error) {
      // Handle exceptions such as network errors
      print('Error pick image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Upload Example'),
      ),
      body: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await _pickPdf();
                    },
                    child: Text('Pick PDF'),
                  ),
                  SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () async {
                      await _uploadPdf();
                    },
                    child: Text('Upload PDF'),
                  ),
                  Text(
                    '$_state',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                        await _uploadImage();
                    },
                    child: Text('Upload Image'),
                  ),
                  Text(
                    '$_uploadImagestate',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ],
      ),
    ),
      );
  }
}