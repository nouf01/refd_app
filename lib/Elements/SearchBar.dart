import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextField(
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Search for resturant',
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF89CDA7),
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
        SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Color(0xFF89CDA7),
            ),
            onPressed: () {},
          ),
        ),
      ],
    ); //row
  }
}
