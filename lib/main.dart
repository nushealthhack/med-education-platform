import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'UploadPdf.dart';
import 'UploadedImagesFolder.dart';
import 'ImagesPage.dart';
import 'ParsedTextPage.dart';
import 'chat_screen.dart';
import 'UploadPdf_Python.dart';
import 'TextViewer.dart';
import 'recognization_page.dart';
import 'display_text.dart';
import 'image_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyMedicine',
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'EasyMedicine'),
        '/upload-pdf': (context) => UploadPdfPage(),
        '/uploaded-images': (context) => MyUploadedImageFoldersPage(title: "Uploaded Images Folder"),
        '/images': (context) => MyImagePage(title: "Uploaded Images"),
        '/parsed-text': (context) => MyParsedTextPage(title: "Parsed Text"),
        '/chat':(context)=>MyChatPage(),
        '/upload-pdf-python':(context)=>Myupload(),
        '/text-viewer' : (context) => TextViewerPage(title: "Text Viewer"),
        '/recognise-page': (context) => MyRecognisePage(),
        '/display-text': (context) => MyDisplayTextPage(),
        '/selected-image':(context) => MySelectedImagePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      )
    );
  }
}

