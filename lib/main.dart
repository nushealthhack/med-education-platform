import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'UploadPdf.dart';
import 'UploadedImagesFolder.dart';
import 'ImagesPage.dart';
import 'ParsedTextPage.dart';
import 'chat_screen.dart';
import 'UploadPdf_Python.dart';
import 'TextViewer.dart';

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
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      )
    );
  }
}

