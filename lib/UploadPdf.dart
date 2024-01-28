import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:med_education_platform/modal_dialog.dart';
import 'package:med_education_platform/recognization_page.dart';
import 'package:med_education_platform/Utils/image_cropper_page.dart';
import 'package:med_education_platform/Utils/image_picker_class.dart';

class UploadPdfPage extends StatefulWidget {
  @override
  UploadPdfPageState createState() => UploadPdfPageState();
}

class UploadPdfPageState extends State<UploadPdfPage> {
  late FilePickerResult _pickedFile;
  late XFile imageTemp;
  String _state = "";
  String _uploadImagestate = "";

  Future<void> _pickPdf() async {
    _pickedFile = (await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    ))!;
  }

  Future<void> _pickImage() async {
    imageTemp = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
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
    // final String apiUrl = 'http://127.0.0.1:5000/upload-pdf';
    
    // try {
    //   final Uint8List bytes = await imageTemp.readAsBytes();

    //   // Create an InputImage from the bytes
    //   final InputImage inputImage = InputImage.fromBytes(
    //     bytes: bytes,
    //     inputImageData: InputImageData(
    //       imageRotation: imageTemp.metadata?.rotation ?? InputImageRotation.rotation0deg,
    //       inputImageFormat: InputImageFormatMethods.fromRawValue(imageTemp.format.group),
    //       size: Size(imageTemp.width.toDouble(), imageTemp.height.toDouble()),
    //     ),
    //   );
    //   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    //   final RecognizedText recognizedText =
    //     await textRecognizer.processImage(inputImage);

    //   Navigator.pushNamed(context, '/parsed-text', arguments: {'text': recognizedText.text});

    // } catch (error) {
    //   // Handle exceptions such as network errors
    //   print('Error: $error');
    // }
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
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImage();
                    },
                    child: Text('Pick Image'),
                  ),
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
    floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(context, onCameraTap: () {
            pickImage(source: ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          }, onGalleryTap: () {
            pickImage(source: ImageSource.gallery).then((value) {
              if (value != '') {
                Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
              }
            });
          });
        },
        tooltip: 'Increment',
        label: const Text("Scan photo"),
      ), );
  }
}