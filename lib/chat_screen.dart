import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyChatPage extends StatelessWidget {
  final String? initialText;
  MyChatPage({this.initialText});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(initialText: initialText),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String? initialText;

  ChatScreen({this.initialText});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<ChatMessage> _messages = [];
  @override
  void initState() {
    super.initState();

    // Fill the text controller with initial text if available
    if (widget.initialText != null) {
      _textEditingController.text = widget.initialText!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat With Easy Medicine Bot'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type a question...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _handleMessageSubmit(_textEditingController.text);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleMessageSubmit(String text) async {
    if (text.isNotEmpty) {
      _textEditingController.clear();
      setState(() {
        _messages.add(ChatMessage(text));
      });

      // Make a POST request to the API with the entered text
      try {
        var access_token = "ya29.a0AfB_byDAjQ-k7edTDztIdo3oA4telGPLp0mONOVobh87I9C-feWxMVkROnfF_bEMgD_mpmDteqAyB5xbMM6rrA9MN785Zcwe3dEOTliSL_jZrEAvBbEn5QAXV6TZ4H3c1aclKbOMzehfABFSKQ4jMT0FY3HIhFO-LI8xzNltw5AD-2fR-PFIrj4woXdBL3TqEF5eio79OL8jZRZFgl0VvZvQbiafjl8yofMzjSr1QqMsSv6tN5fFePiMnwqNUKjJbrohmVqCL5pRy8u_sjLSblhKxxkvo6bIlkr24xJykcm9onr4Wqp27muKAuNllpy21yCA8ubeQHZLyN88Dj9OT15m-fvkNjRX2yJX2XcgDQEtS7qmTQ61BGCqUar6DWMcibT97UsX8t9myetxsD4n963Oqhb40Mb8aCgYKAeYSARMSFQHGX2Mi9t3zWcaXR6Jkkm1XoUlE5w0423";
        var url = "https://us-central1-aiplatform.googleapis.com/v1/projects/healthhack-412317/locations/us-central1/publishers/google/models/chat-bison:predict?access_token=$access_token";
        print(url);
        final response = await http.post(
          Uri.parse(url), // Replace with your API endpoint
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
          "instances": [
          {
          "context": "You are to explain medical reports to people who does not understand complex terms. Please breakdown the medical jargons and explain it to them as simply as you can. Explain if it is a positive or negative result. After this is done if the result is negative please provide a suggestion to help combat the issue",
          "examples": [
          {
          "input": {
          "content": "No Trichomonas or Candida organisms are seen."
          },
          "output": {
          "content": """These are organisms that cause infections. Trichomonas is a protozoan parasite causing the sexually transmitted infection trichomoniasis, primarily affecting the urogenital tract in both men and women. 
          While Candida is a genus of yeast, with Candida albicans being a common species that can cause various infections, including yeast infections in the genital or oral areas, skin, nails, and mucous membranes. """
          }
          }
          ],
          "messages": [
          {
          "author": "User",
          "content": text
          }
          ]
          }
          ]
          }),
        );

        if (response.statusCode == 200) {
          // Display the API response in the chat
          print(response);

          final responseBody = jsonDecode(response.body);
          print("=====");
          print(responseBody);
          final botResponse = responseBody['predictions'][0]['candidates'][0]['content'];
          setState(() {
            _messages.add(ChatMessage(botResponse, isBot: true));
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        print('Error exception: $e');
      }
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;

  ChatMessage(this.text, {this.isBot = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isBot ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
