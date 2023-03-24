import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? file;

  void takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    setState(() {
      file = pickedFile;
    });
  }

  void submit() async {
    try {
      var formData = FormData.fromMap({
        'data': jsonEncode({
          "question": {
            "idQuestion": "e17a5d9e-51da-4f56-a8e0-02b32a8d6768",
            "typeQuestion": "closed",
            "answers": false,
            "idChallengeActivated": "50c1f75b-e19e-46d8-95f3-dd4488617e4c",
            "evidences": true,
            "conditional": null
          }
        }),
        'file': MultipartFile.fromFile(file!.path,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg'),
      });

      var response = await Dio().post(
        'here api',
        options: Options(
          contentType: 'multipart/form-data',
        ),
        data: formData,
      );
      print(response.statusCode);
    } on DioError catch (e) {
      print(e.response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: takePicture,
              child: Card(
                child: file != null
                    ? kIsWeb
                        ? Image.network(
                            file!.path,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          )
                        : Image.file(File(file!.path))
                    : const Text('Take a picture'),
              ),
            ),
            ElevatedButton(
              onPressed: submit,
              child: const Text('Enviar la informacion'),
            )
          ],
        ),
      ),
    );
  }
}
