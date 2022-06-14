import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/item_button.dart';
import 'package:path/path.dart';

class MyFiles extends StatefulWidget {
  const MyFiles({Key? key}) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  List<FileSystemEntity> files = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listOfFiles();
  }
  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    files.clear();
  }

  void deleteFile(int i) {
    setState(() {
      files[i].delete();
      files.removeAt(i);
    });
  }

  void open(int i) {
    OpenFile.open(files[i].path);
  }

  void _listOfFiles() async {
    Directory dir = await getApplicationDocumentsDirectory();
    setState(() {
      List<FileSystemEntity> tempFiles = Directory(dir.path + "/").listSync();
      files = tempFiles.where((i)=> basename(i.path.toString()).startsWith('My Collage ')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'My Files',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        (files.isEmpty)
            ? const Expanded(
                flex: 10,
                child: Center(
                    child: Text(
                  'Empty folder.',
                )),
              )
            : Expanded(
                flex: 10,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                        return ItemButton(
                            dateTime:
                                FileStat.statSync(files[index].path.toString())
                                    .accessed
                                    .toString(),
                            name: basename(files[index].path.toString()),
                            id: index,
                            delete: deleteFile,
                            open: open);
                    },
                  ),
                )),
      ],
    );
  }
}
