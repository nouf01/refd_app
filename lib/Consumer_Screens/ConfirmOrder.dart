import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/HomeScreenConsumer.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/Provider.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';
import '../Elements/restaurantInfo.dart';

class ConfirmOrder extends StatefulWidget {
  //>>>>>>>>>>> Here must be the concumerCart
  const ConfirmOrder({super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  Database DB = Database();
  Provider? prov;
  Consumer? currentUser;
  List<DailyMenu_Item>? cart;
  double? total;

  Future<void> _initRetrieval() async {
    currentUser = Consumer.fromDocumentSnapshot(
        await DB.searchForConsumer('nouf888s@gmail.com'));
    total = currentUser!.cartTotal;
    cart = await DB.retrieve_Cart_Items('nouf888s@gmail.com');
    prov = Provider.fromDocumentSnapshot(
        await DB.searchForProvider(cart![0].getItem().get_providerID));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    if (prov == null) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        body: Stack(children: [
          SafeArea(
            child: Column(
              children: [
                restaurantInfo(
                  currentProve: prov!,
                ),
                Container(
                  height: 260,
                  child: Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 0.1,
                      ),
                      shrinkWrap: true,
                      itemCount: cart!.length,
                      padding: EdgeInsets.all(4),
                      itemBuilder: (context, index) => Card(
                        elevation: 0,
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "${cart![index].getChoosedCartQuantity} x ${cart![index].getItem().get_name()} ",
                                  // maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                (cart![index].getPriceAfetr_discount *
                                        cart![index].getChoosedCartQuantity)
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                      bottom: 8.0,
                      top: 4.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  total!.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  "Total is include VAT",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 20,
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment method is pay on store,",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "You can cancel your order only if it's still under processing ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Note: If you do not pickup your order for a certain number of times, you will not be able to use the application again!",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16.0,
                                  ),
                                  primary: Colors.green,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "your order placed sucessfully!",
                                      ),
                                      content: Text(
                                        " you can track it in the order history screen",
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          child: Text("OK"),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrdersHistoryScreen()));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                child: Text("Confirm my order"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
