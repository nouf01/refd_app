import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/item.dart';

void main() async {
  //Change 9:55
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Database db = Database();

  Provider currentProvider = Provider.fromDocumentSnapshot(
      await db.searchForProvider('MacDonalds2008'));

  print('----------------------------------------------------');
  print(currentProvider.getUsername);

  Item item1 = Item(
      providerID: currentProvider.getUsername,
      name: 'Sandwitch2222',
      description: 'Describe Sandwitch',
      originalPrice: 5.6);

  Item item2 = Item(
      providerID: currentProvider.getUsername,
      name: 'Burger',
      description: 'Describe Burger',
      originalPrice: 17.2);

  Item item3 = Item(
      providerID: 'Starbucks22222',
      name: 'Coffee',
      description: 'Describe Coffee',
      originalPrice: 10.99);

  var theList = await db.retrieveMenuItems('MacDonalds2008');
  theList.forEach((element) {
    print(element.description);
  });

  List<DailyMenu_Item> dmList =
      await db.retrieve_DMmenu_Items(currentProvider.getUsername);

  //db.removeFromPrvoiderDM(currentProvider.getUsername, dmList[0].getUid);
  db.update_DM_Item_Info(
      currentProvider.getUsername, dmList[0].getUid, {'quantity': 2});
}


/*import 'package:flutter/material.dart';
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
*/