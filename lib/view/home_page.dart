import 'package:flutter/material.dart';
import 'package:photo_collage/view/screens/create_widget.dart';
import 'package:photo_collage/view/screens/my_files_widget.dart';


//
// List<String> titles= ['Create Collage','My Files'];
List<Widget> screens= [const Create(),const MyFiles()];
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageViewController = PageController();
  int _index = 0;
  void _onItemTapped(int index) {
    _pageViewController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffeafafa),
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          screens[0],
          screens[1]

        ],
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // backgroundColor: globals.navigationBarColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Files',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
