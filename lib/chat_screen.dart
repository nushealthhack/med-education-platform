import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MyChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat With Easy Medicine Bot'),
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
        var access_token = "ya29.a0AfB_byDJrBKiUzCiaTDwYYApL-B5wug9_OEvxTZp-MJgseqFPWMJLUxjjrvqFcKC32_KqqsGLLqyVHh-TaRcGvQhibyCgQUN4g3sFrghVh6950YEB7ohIRTrwlvkfsCxb9_JcAdWdqDdbvWyLKVXcUSpSchz-eSaF2ovOWcf0xcZvYWa_LhdRtk6xtv4F8jB9kqYAXONWBYV1cBKuirDwHFqTxeK8v4XM01NFNYa9d6w4d2Kcfhewipq8SW3K2m1k2awB9xLwqU9C6z5_tDnqvelQ0vAZY0BmMHG1pwDCJ3qevwUnbgpNEWh0sjX7dVSBcgUQNgn3UE0Srt1mA-EGeO6ElgPtCrwF_nVqoNwg1Rq_e3bB57jXLfXMA8iXwHeoi5dbLykOAf2BNg2pgFLmdT0n4fDx9gmaCgYKAdwSARMSFQHGX2MiRK3dEpmf6uu4NsAHSrLmqA0423";
        var url = "https://us-central1-aiplatform.googleapis.com/v1/projects/healthhack-412317/locations/us-central1/publishers/google/models/chat-bison:predict?access_token=$access_token";
        print(url);
        final response = await http.post(
          Uri.parse(url), // Replace with your API endpoint
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
          "instances": [
          {
          "context": "You are to explain medical reports to people who does not understand complex terms. Please breakdown the medical jargons and explain it to them as simply as you can. Explain if it is a positive or negative result",
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
