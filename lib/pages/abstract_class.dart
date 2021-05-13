import 'add_inventory_stub.dart'
    if (dart.library.io) 'add_inventory_picture.dart'
    if (dart.library.js) 'add_inventory_picture_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

abstract class AddPicture extends StatefulWidget {
  static AddPicture _instance;
  String barcode;

  // AddPicture(this.barcode, {Key key}) : super(key: key);
  deletePicture(String item) {}
  factory AddPicture({String key}) => getPictureClass(key);
}
