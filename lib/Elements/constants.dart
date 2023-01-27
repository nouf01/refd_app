import 'package:flutter/material.dart';

const kTileHeight = 50.0;
const inProgressColor = Colors.black87;
const todoColor = Color(0xffd1d2d7);

enum Status {
  underProcess,
  waitingForPickUp,
  pickedUp,
  canceled,
}
class Constants {
  //TODO: PLACE YOUR API-KEY
  static const String apiKey = "AIzaSyC02VeFbURsmFAN8jKyl_OhoqE0IMPSvQM";
}
