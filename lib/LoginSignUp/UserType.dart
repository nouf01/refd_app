import 'package:flutter/material.dart';
import 'package:refd_app/LoginSignUp/providerSign/ProviderLogIn.dart';

import 'consumer/ConsumerLogIn.dart';

class UserType extends StatelessWidget {
  const UserType({super.key});

  @override
  Widget build(BuildContext context) {
    double Screenwidth = MediaQuery.of(context).size.width;
    double Screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, backgroundColor: Color(0xFF66CDAA)),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Center(
              child: Container(
                  margin: const EdgeInsets.only(top: 140),
                  width: Screenwidth,
                  alignment: Alignment.center,
                  child: const Text(
                    "Welcome to Refd",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assests/ShoppingBag.png"))),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
                alignment: Alignment.center,
                child: const Text(
                  "How would you like to proceed as?",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 330,
              height: 45,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ConsumerLogIn()),
                    );
                  },
                  child: const Text(
                    "Consumer",
                    selectionColor: Colors.white,
                    style: TextStyle(fontSize: 27),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF66CDAA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  )),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: 330,
              height: 45,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProviderLogIn()),
                    );
                  },
                  child: const Text(
                    "Provider",
                    selectionColor: Colors.white,
                    style: TextStyle(fontSize: 27),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF66CDAA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
