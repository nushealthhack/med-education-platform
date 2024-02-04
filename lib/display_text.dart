import 'package:flutter/material.dart';
import 'UploadPdf_Python.dart';

class MyDisplayTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Text Page')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'The uterus is tilted forward (anteverted) and is of normal size and appearance (echogenicity). Its dimensions are 6.6 cm in length, 4.4 cm in width, and 2.8 cm in depth. There are no concerning areas or growths (focal lesions) within the uterus. The endometrium, which is the lining of the uterus, appears uniform (homogenous) and is not thickened. The thickness of the endometrium is 0.5 cm, which is within the normal range. Overall, this description suggests that the uterus and endometrium appear normal on this examination.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context, '/chat', arguments: {'text': 'The uterus is tilted forward (anteverted) and is of normal size and appearance (echogenicity). Its dimensions are 6.6 cm in length, 4.4 cm in width, and 2.8 cm in depth. There are no concerning areas or growths (focal lesions) within the uterus. The endometrium, which is the lining of the uterus, appears uniform (homogenous) and is not thickened. The thickness of the endometrium is 0.5 cm, which is within the normal range. Overall, this description suggests that the uterus and endometrium appear normal on this examination.'}
                  );
                },
                child: Text('Send to Chat Bot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}