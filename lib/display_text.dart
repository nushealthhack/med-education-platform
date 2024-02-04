import 'package:flutter/material.dart';
import 'UploadPdf_Python.dart';

class MyDisplayTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Extracted Text')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Indication: Screening ULTRASOUND PELVIS: COMPARISON: No previous study is available on the system for comparison at the time of reporting.FINDINsdfsdfsdfsdfsdfsdfsdfsdfwerwerGS:Transabdominal scans were obtained.Menopausal.The uterus is anteverted and is normal in size and echogenicity. It measures 6.6 x 4.4 x 2.8 cm. Thereare no focal lesions. The endometrium is homogenous and is not thickened, measuring 0.5 cm.The ovaries were not visualised .No adnexal masses or free fluid are seen in the pelvis.Comment: Normal ultrasound pelvis.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context, '/chat', arguments: {'text': 'Indication: Screening ULTRASOUND PELVIS: COMPARISON: No previous study is available on the system for comparison at the time of reporting.FINDINsdfsdfsdfsdfsdfsdfsdfsdfwerwerGS:Transabdominal scans were obtained.Menopausal.The uterus is anteverted and is normal in size and echogenicity. It measures 6.6 x 4.4 x 2.8 cm. Thereare no focal lesions. The endometrium is homogenous and is not thickened, measuring 0.5 cm.The ovaries were not visualised .No adnexal masses or free fluid are seen in the pelvis.Comment: Normal ultrasound pelvis.'}
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