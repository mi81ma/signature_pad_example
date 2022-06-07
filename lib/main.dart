import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(secondary: Colors.blueAccent),
        ),
        home: const MyHomePage());
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ProjectFormPage();
    return HandWriting();
  }
}

class HandWriting extends HookConsumerWidget {
  // const HandWriting({Key? key}) : super(key: key);

//   @override
//   State<HandWriting> createState() => _HandWritingState();
// }

// class _HandWritingState extends State<HandWriting> {
  Uint8List? exportedImage;
  final exportedImageState = useState(Uint8List(0));

  final controller = useState(SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white12));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Signature Pad Example"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Signature(
              controller: controller.value,
              width: 350,
              height: 200,
              backgroundColor: Colors.grey[300]!,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () async {
                          var testController = controller.value;
                          print("controller.value: $testController");
                          exportedImageState.value =
                              (await controller.value.toPngBytes()) ??
                                  Uint8List(0);
                          // ignore: avoid_print
                          var test2 = (await controller.value.toPngBytes());

                          print("exportedImageState.value: $test2");
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          controller.value.clear();
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (exportedImageState.value != null ||
                exportedImageState.value != [0])
              Image.memory(
                exportedImageState.value,
                width: 300,
                height: 250,
              )
            else
              Container(
                width: 300,
                height: 250,
                color: Colors.blue,
              )
          ],
        ),
      ),
    );
  }
}
