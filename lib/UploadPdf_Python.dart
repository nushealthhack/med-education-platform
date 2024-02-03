import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package for MediaType
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';

import 'chat_screen.dart';


class Myupload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: upload(),
    );
  }
}

class upload extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<upload> {

    @override
  Widget build(BuildContext context) {
  final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
  final String _extractedText = arguments['text'];
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Uploader'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick PDF File'),
            ),
            SizedBox(height: 20),
            if (_pickedFile != null)
              Text(
                'Selected File: ${_pickedFile!.path}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload PDF File'),
            ),
            SizedBox(height: 20),
            if (_extractedText != null)
              ElevatedButton(
                onPressed: _sendToChatBot,
                child: Text('Send to Chat Bot'),
              ),
          ],
        ),
      ),
    );
  }

  File? _pickedFile;
  String? _extractedText;

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_pickedFile == null) {
      // No file selected
      return;
    }

    final url = 'https://healthhack.onrender.com//process_pdf'; // Replace with your server endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _pickedFile!.path,
          contentType: MediaType('application', 'pdf'),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successful response
        var responseBody = jsonDecode(await response.stream.bytesToString());
        print(responseBody);
        setState(() {
          _extractedText = responseBody['result'];
        });
      } else {
        // Error response
        print('Error: ${response.statusCode}, ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void _sendToChatBot() {
    if (_extractedText != null) {
      // Replace this with your chat bot interaction logic
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyChatPage(initialText:_extractedText),
          ));
      print('Sending to chat bot: $_extractedText');
    } else {
      print('No extracted text available');
    }
  }


}
