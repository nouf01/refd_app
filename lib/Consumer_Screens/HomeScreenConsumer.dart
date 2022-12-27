// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flexi_chip/flexi_chip.dart';
import 'package:refd_app/Provider_Screens/Menu.dart';

import '../Elements/SearchBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database service = Database();
  Future<List<Provider>>? provList;
  List<Provider> retrievedprovList = [];
  List<Tags> listTags = [
    Tags.coffee,
    Tags.grocery,
    Tags.pizza,
    Tags.bakery,
    Tags.sweets,
    Tags.fastFood,
    Tags.jucies,
    Tags.grill,
    Tags.saudi,
  ];
  List<Tags> choosedTags = []; //choosed tags
  int tag = 0;

  List<Provider>? searchMatched = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.location_pin),
          onPressed: () {},
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(fontSize: 13),
            ),
            Text(
              'AlHamra, Riyadh 13525',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ChipsChoice<Tags>.multiple(
              value: choosedTags,
              onChanged: ((value) {
                setState(() {
                  choosedTags = value;
                });
                _refresh();
              }),
              choiceItems: C2Choice.listFrom(
                source: listTags,
                value: (i, v) => v,
                label: (i, v) => v.toString().replaceAll('Tags.', ''),
              ),
              choiceStyle: FlexiChipStyle.when(
                  selected: const C2ChipStyle(
                      checkmarkColor: Colors.green,
                      backgroundColor: Colors.green,
                      foregroundStyle: TextStyle(color: Colors.black))),
              choiceCheckmark: true,
            ),
          ),
          TextField(
            onChanged: ((value) => _search(value)),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search for resturant',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.green,
                ),
                contentPadding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, top: 12.5),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10))),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder(
                  future: provList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Provider>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.separated(
                          itemCount: retrievedprovList!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemBuilder: (context, index) {
                            Provider p1 = retrievedprovList![index];
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MenuScreen(
                                                currentProv:
                                                    retrievedprovList![index],
                                              )));
                                },
                                leading: Image.network(
                                    '${retrievedprovList![index].get_logoURL}'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                title: Text(retrievedprovList![index]
                                    .get_commercialName),
                                subtitle: Text(
                                    "${retrievedprovList![index].get_tags[0]},   ${retrievedprovList![index].get_rate}"),
                                trailing: const Icon(Icons.arrow_right_sharp),
                              ),
                            );
                          });
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        retrievedprovList!.isEmpty) {
                      return Center(
                        child: ListView(
                          children: const <Widget>[
                            Align(
                                alignment: AlignmentDirectional.center,
                                child: Text('No data available')),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }), //future
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    if (choosedTags!.isEmpty) {
      provList = service.filterProvider(listTags);
      retrievedprovList = await service.filterProvider(listTags);
    } else {
      provList = service.filterProvider(choosedTags);
      retrievedprovList = await service.filterProvider(choosedTags);
    }
    setState(() {});
  }

  void _search(String input) async {
    if (input.isEmpty) {
      _refresh();
    } else {
      retrievedprovList =
          await service.searchForProviderByName(input.toLowerCase());
      setState(() {});
    }
  }

  Future<void> _initRetrieval() async {
    if (choosedTags!.isEmpty) {
      provList = service.filterProvider(listTags);
      retrievedprovList = await service.filterProvider(listTags);
      searchMatched = retrievedprovList;
    } else {
      provList = service.filterProvider(choosedTags);
      retrievedprovList = await service.filterProvider(choosedTags);
    }
  }
}
