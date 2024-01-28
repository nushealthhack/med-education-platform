import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class UploadPdfPage extends StatefulWidget {
  @override
  UploadPdfPageState createState() => UploadPdfPageState();
}

class UploadPdfPageState extends State<UploadPdfPage> {
  late FilePickerResult _pickedFile;
  String _state = "";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Upload Example'),
      ),
      body: Center(
        child: Column(
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
      ),
    );
  }
}