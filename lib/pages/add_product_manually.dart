import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_gentelella/constants/page_titles.dart';
import 'package:flutter_gentelella/widgets/app_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'add_inventory_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'abstract_class.dart';

class Product {
  String aisle;
  String name;
  String price;
  String barcodeid;
  String quantity;

  Product({this.aisle, this.name, this.price, this.quantity, this.barcodeid});
}

class MyCustomForm extends StatefulWidget {
  //MyCustomForm({Key key, this.productid}) : super(key: key);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //File _image;
  String _uploadedFileURL;
  PickedFile imaged;
  File _image;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final firestoreInstance = cf.FirebaseFirestore.instance;
  TextEditingController aisle = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController productname = TextEditingController();
  TextEditingController barcodeid = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return AppScaffold(
      pageTitle: PageTitles.add_product,
      //appBar: AppBar(title: Text("Create a New Inventory Item")),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: aisle,
              decoration: const InputDecoration(
                icon: const Icon(Icons.local_grocery_store),
                hintText: 'Enter the aisle',
                labelText: 'Aisle',
              ),
            ),
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: barcodeid,
              decoration: const InputDecoration(
                icon: const Icon(Icons.local_grocery_store),
                hintText: 'Enter the barcode or product id',
                labelText: 'barcode',
              ),
            ),
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: quantity,
              decoration: const InputDecoration(
                icon: const Icon(Icons.shopping_bag),
                hintText: 'Enter quantity',
                labelText: 'Quantity',
              ),
            ),
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: price,
              decoration: const InputDecoration(
                icon: const Icon(Icons.shopping_bag),
                hintText: 'Enter price',
                labelText: 'price',
              ),
            ),
            TextFormField(
              style: TextStyle(color: Colors.black),
              controller: productname,
              decoration: const InputDecoration(
                icon: const Icon(Icons.shopping_basket),
                hintText: 'Enter name of product',
                labelText: 'Product Name',
              ),
            ),
            new Container(
                padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    print(productname);
                    print(aisle);
                    print(quantity);
                    firestoreInstance
                        .collection('SLJ0i3hJMg8fNvCwdLOY')
                        .doc(barcodeid.text)
                        .set({
                      "aisle": aisle.text,
                      "name": productname.text,
                      "quantity": int.parse(quantity.text),
                      "price": price.text
                    });
                    //if (kIsWeb) {
                    //Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) =>
                    //      AddPictureHTML(barcodeid.text)));
                    //} else {
                    AddPicture concretePictureClass =
                        AddPicture(key: this.barcodeid.text);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => concretePictureClass));
                    //}
                  },
                )),
          ],
        ),
      ),
    );
  }
}
