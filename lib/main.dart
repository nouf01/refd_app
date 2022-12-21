import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/Cart_Screen/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/Home_Screen/HomeScreen.dart';
import 'package:refd_app/Consumer_Screens/Maps_Screen/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/Orders_History_Screen/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen/Profile_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pageIndex = 0;
  static const List<Widget> _Pages = [
    HomeScreen(),
    MapsScreen(),
    CartScreen(),
    OrdersHistoryScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void createUser({required String name}) async {
    final docUser =
        FirebaseFirestore.instance.collection('Providers').doc(name);
    final jsonMap = {
      'name': name,
      'Age': 30,
      'Location': 'Riyadh',
    };
    docUser.set(jsonMap);
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: TextField(
                controller: controller,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    final name = controller.text;
                    createUser(name: name);
                  },
                  icon: Icon(Icons.add),
                )
              ],
              backgroundColor: Colors.green),
          body: _Pages.elementAt(_pageIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Maps',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Cart',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Orders History',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.green,
              ),
            ],
            currentIndex: _pageIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          )),
    );
  }
}
