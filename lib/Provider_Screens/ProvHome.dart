// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:slider_button/slider_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Elements/listOfOrdersWidget.dart';
import 'package:refd_app/Elements/restaurantInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../DataModel/Provider.dart';
import '../messaging_service.dart';

class HomeScreenProvider extends StatefulWidget {
  const HomeScreenProvider({super.key});

  @override
  State<HomeScreenProvider> createState() => _HomeScreenProviderState();
}

class _HomeScreenProviderState extends State<HomeScreenProvider> {
  LoggedProvider log = LoggedProvider();
  Database db = Database();
  Provider? p;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    if (p == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                toolbarHeight: 120,
                leadingWidth: 80,
                /*leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: ClipOval(
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        p!.get_logoURL,
                        height: 110,
                        width: 10,
                        fit: BoxFit.cover,
                      )),
                ),*/
                title: Column(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          ClipOval(
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                p!.get_logoURL,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )),
                          SizedBox(
                            width: 80,
                          ),
                          Container(
                              child: Center(
                            child: Text(
                              p!.get_commercialName,
                              textAlign: TextAlign.center,
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: LiteRollingSwitch(
                        width: 300,
                        value: p!.get_isOpen() == 0 ? false : true,
                        textOn: 'open',
                        textOff: 'closed',
                        colorOn: Color.fromARGB(255, 75, 177, 143),
                        colorOff: Colors.grey,
                        textOnColor: Colors.white,
                        iconOn: Icons.store,
                        iconOff: Icons.event_busy_outlined,
                        onChanged: (bool state) {
                          if (state) {
                            Database _db = Database();
                            _db.updateProviderInfo(p!.get_email, false,
                                p!.get_commercialName, {'isOpenNow': 1});
                            print(
                                "${p!.get_isOpen()}+++++++++++++++++++++++++++++++++");
                          } else {
                            Database _db = Database();
                            _db.updateProviderInfo(p!.get_email, false,
                                p!.get_commercialName, {'isOpenNow': 0});
                            print(
                                "${p!.get_isOpen()}+++++++++++++++++++++++++++++++++");
                          }
                          print('turned ${(state) ? 'on' : 'off'}');
                        },
                        onDoubleTap: () => null,
                        onSwipe: () => null,
                        onTap: () => null,
                      ),
                    )
                  ],
                ),
                backgroundColor: Color(0xFF89CDA7),

                /*actions: [
                  SliderButton(
                    action: () {
                      ///Do something here OnSlide
                      print("working");
                    },

                    ///Put label over here
                    label: Text(
                      "Slide to cancel !",
                      style: TextStyle(
                          color: Color(0xff4a4a4a),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    icon: Center(
                        child: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 40.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )),

                    //Put BoxShadow here
                    boxShadow: BoxShadow(
                      color: Colors.black,
                      blurRadius: 4,
                    ),

                    //Adjust effects such as shimmer and flag vibration here
                    shimmer: true,
                    vibrationFlag: true,

                    ///Change All the color and size from here.
                    width: 230,
                    radius: 10,
                    buttonColor: Color(0xffd60000),
                    backgroundColor: Color(0xff534bae),
                    highlightedColor: Colors.white,
                    baseColor: Colors.red,
                  ),
                ],*/
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text('Under process',
                            style: TextStyle(fontSize: 15))),
                    Tab(
                        child: Text('Waiting for pickup',
                            style: TextStyle(fontSize: 15))),
                  ],
                )),
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFF89CDA7),
            body: TabBarView(
              children: [
                listOfOrders(status: 0, provID: p!.get_email),
                listOfOrders(status: 1, provID: p!.get_email),
              ],
            ),
          )),
    );
  }

  Future<void> _initRetrieval() async {
    p = await log.buildProvider();
    MessagingService _msgService =
        MessagingService(isProv: true, userID: p!.get_email);
    await _msgService.init();
    setState(() {});
  }
}
