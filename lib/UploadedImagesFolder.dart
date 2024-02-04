import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'image_screen.dart';

class MyUploadedImageFoldersPage extends StatefulWidget {
  const MyUploadedImageFoldersPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyUploadedImageFoldersPage> createState() => _MyUploadedImageFolderPageState();
}

class _MyUploadedImageFolderPageState extends State<MyUploadedImageFoldersPage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        // child: TableWidget()
      ),
    );
  }
}

// class TableWidget extends StatelessWidget {

  // final String apiUrl = 'http://127.0.0.1:5000/get-folders'; 
  // Future<List<String>> fetchImageUrls() async {
  //   final response = await http.get(Uri.parse(apiUrl));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return List<String>.from(data.map((dynamic item) => item));
  //   } else {
  //     throw Exception('Failed to load image URLs');
  //   }
  // }

  @override
  // Widget build(BuildContext context) {
    // return FutureBuilder<List<String>>(
      // future: fetchImageUrls(),
      // builder: (context, snapshot) {
      //   if (snapshot.connectionState == ConnectionState.waiting) {
      //     return Center(child: CircularProgressIndicator());
      //   } else if (snapshot.hasError) {
      //     return Center(child: Text('Error: ${snapshot.error}'));
      //   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //     return Center(child: Text('No image URLs available'));
      //   } else {
      //     return ListView.builder(
      //       itemCount: (snapshot.data!.length / 2).ceil(),
      //       itemBuilder: (context, index) {
      //         if (snapshot.data!.length % 2 != 0 && index == (snapshot.data!.length - 1) / 2) {
      //           return TableRowWidget(
      //             rowImageUrls: snapshot.data!.sublist(index * 2, (index * 2) + 1),
      //           );
      //         }
      //         return TableRowWidget(
      //           rowImageUrls: snapshot.data!.sublist(index * 2, (index * 2) + 2),
      //         );
      //       },
      //     );
      //   }
      // },
    // );
  // }
// }

class TableRowWidget extends StatelessWidget {
  final List<String> rowImageUrls;

  TableRowWidget({required this.rowImageUrls});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: rowImageUrls.map((imageUrl) => ImageCell(imageUrl: imageUrl)).toList(),
      )
    );
  }
}

class ImageCell extends StatelessWidget {
  final String imageUrl;

  ImageCell({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {
              Navigator.pushNamed(context, '/selected-image')
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/folder-icon.jpg'),
            ),
          ),
          SizedBox(height: 8.0), // Adjust the spacing between image and text
          Text(
            imageUrl,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
