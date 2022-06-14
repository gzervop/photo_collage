import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:photo_collage/view/widgets/image_in_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  List<File> images = [];
  String pdfFile = '';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late int _counter;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _counter++;
    });
    prefs.setInt('counter', _counter);
  }

  _loadArr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadArr();
  }

  @override
  void dispose() {
    super.dispose();
    images.clear();
  }

  Future selectFromCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    final tempImage = File(image.path);
    setState(() {
      images.add(tempImage);
    });
  }

  Future selectFromGallery() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final tempImage = File(image.path);
    setState(() {
      images.add(tempImage);
    });
  }

  createPdfFile() async {
    var pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.GridView(
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              crossAxisCount: 2,
              childAspectRatio: 1,
              children: images.map((image) {
                return pw.Container(
                  child: pw.Image(pw.MemoryImage(
                    image.readAsBytesSync(),
                  )),
                );
              }).toList(),
            ),
          ];
        }));
    return pdf;
  }

  savePdfFile(pw.Document pdf) async {
    String fileName = 'My Collage ' + _counter.toString() + '.pdf';
    _incrementCounter();
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/$fileName');
    file.writeAsBytesSync(await pdf.save());

    OpenFile.open('$path/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Collage',
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectFromCamera();
                          },
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            selectFromGallery();
                          },
                          child: const Icon(
                            Icons.add_photo_alternate,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            (images.isEmpty)
                ? const Expanded(
                    flex: 10,
                    child: Center(
                        child: Text(
                      'No photos selected.',
                    )),
                  )
                : Expanded(
                    flex: 10,
                    child: SingleChildScrollView(
                      child: GridView.count(
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.2),
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        children: <Widget>[
                          for (int i = 0; i < images.length; i++)
                            GestureDetector(
                              onTap: () {
                                if (i < images.length - 1) {
                                  setState(() {
                                    final element = images.removeAt(i);
                                    images.insert(i + 1, element);
                                  });
                                }
                              },
                              child: ImageInList(
                                file: images[i],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        (images.isEmpty)
            ? Container()
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: () async {
                      var pdf = await createPdfFile();
                      savePdfFile(pdf);
                    },
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.save_alt),
                  ),
                ),
              ),
      ],
    );
  }
}
