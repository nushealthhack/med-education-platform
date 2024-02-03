import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyImagePage extends StatefulWidget {
  const MyImagePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyImagePage> createState() => _MyImagePageState();
}

class _MyImagePageState extends State<MyImagePage> {

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final String url = arguments['imageUrl'];
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
        child: TableWidget(url: url)
      ),
    );
  }
}

class TableWidget extends StatelessWidget {
  TableWidget({required this.url});
  final String url;

  final String apiUrl = 'http://127.0.0.1:5000/get-images-folders?folder='; // Replace with your API endpoint

  Future<List<String>> fetchImageUrls() async {
    final response = await http.get(Uri.parse(apiUrl + url));

    if (response.statusCode == 200) {
      // final List<dynamic> data = json.decode(response.body);
      // return List<String>.from(data.map((dynamic item) => item));
      final String body = response.body;
      final images = json.decode(body) as Map<String, dynamic>;
      var flutterImages = [];
      for (var imageBase64String in images['images']) {
        var str = imageBase64String.toString();
        flutterImages.add(str);
      } 
      return flutterImages.map((dynamic element) {
        return element.toString();
      }).toList();

    } else {
      throw Exception('Failed to load image URLs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchImageUrls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No image URLs available'));
        } else {
          return ListView.builder(
            itemCount: (snapshot.data!.length / 2).ceil(),
            itemBuilder: (context, index) {
              if (snapshot.data!.length % 2 != 0 && index == (snapshot.data!.length - 1) / 2) {
                return TableRowWidget(
                  rowImageUrls: snapshot.data!.sublist(index * 2, (index * 2) + 1),
                );
              }
              return TableRowWidget(
                rowImageUrls: snapshot.data!.sublist(index * 2, (index * 2) + 2),
              );
              return null;
            },
          );
        }
      },
    );
  }
}

class TableRowWidget extends StatelessWidget {
  final List<String> rowImageUrls;

  TableRowWidget({required this.rowImageUrls});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: rowImageUrls.map((imageString) => ImageCell(image: imageString)).toList(),
      )
    );
  }
}

class ImageCell extends StatelessWidget {
  final String image;

  ImageCell({required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(
            base64Decode(image),
            width: 500,
            height: 500,
            fit: BoxFit.cover, // Choose the appropriate BoxFit
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed (context, '/text-viewer', arguments: {'text': image});
            }
          ),
          SizedBox(height: 8.0), // Adjust the spacing between image and text
          // Text(
          //   imageUrl,
          //   style: TextStyle(fontSize: 16.0),
          // ),
        ],
      ),
    );
  }
}
