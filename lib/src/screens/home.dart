import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

final dataProvider = StateProvider<dynamic>((ref) {
  return;
});

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  File? _image;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() {
      widget._image = imageTemp;
    });
  }

  Future getCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      widget._image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/test.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Welcome to HTR"),
            ),
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await getCamera();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Your Image"),
                                content: Image.file(
                                  widget._image!,
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        final bytes =
                                            widget._image!.readAsBytesSync();
                                        String img64 = base64Encode(bytes);
                                        var post_data = {
                                          "img_data": img64.toString()
                                        };
                                        var response = await http.post(
                                            Uri.parse(using + "/"),
                                            body: post_data);

                                        var data = jsonDecode(
                                            response.body.toString());
                                        // ref.watch(dataProvider.notifier).state =
                                        //     data;
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Converted Text"),
                                              content: Text(
                                                  data["result"].toString()),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Ok")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Clipboard.setData(new ClipboardData(text: data.toString()));
                                                      SnackBar snackBar = SnackBar(
                                                          content: Text(
                                                              "Text has been copied!"));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                    child: Text("Copy"))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Convert"))
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          " Scan  ",
                          style: TextStyle(fontSize: 40),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await pickImage();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Your Image"),
                                content: Image.file(
                                  widget._image!,
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        final bytes =
                                            widget._image!.readAsBytesSync();
                                        String img64 = base64Encode(bytes);
                                        var post_data = {
                                          "img_data": img64.toString()
                                        };
                                        var response = await http.post(
                                            Uri.parse(using + "/"),
                                            body: post_data);
                                        var data = jsonDecode(
                                            response.body.toString());
                                        // ref.watch(dataProvider.notifier).state =
                                        //     data;
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Converted Text"),
                                              content: Text(
                                                  data["result"].toString()),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Ok")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Clipboard.setData(new ClipboardData(text: data.toString()));
                                                      SnackBar snackBar = SnackBar(
                                                          content: Text(
                                                              "Text has been copied!"));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    },
                                                    child: Text("Copy"))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Convert"))
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "Upload",
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        )),
                  ]),
            )));
  }
}
