import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'abstract_class.dart';

class Product {
  String aisle;
  String name;
  String price;
  String barcodeid;
  String quantity;

  Product({this.aisle, this.name, this.price, this.quantity, this.barcodeid});
}

class MyCustomFormBarcode extends StatefulWidget {
  String productid;
  MyCustomFormBarcode({Key key, this.productid}) : super(key: key);
  @override
  MyCustomFormBarcodeState createState() {
    return MyCustomFormBarcodeState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormBarcodeState extends State<MyCustomFormBarcode> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = cf.FirebaseFirestore.instance;
  TextEditingController aisle = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController productname = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return new Scaffold(
      appBar: AppBar(title: Text(widget.productid)),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: aisle,
              decoration: const InputDecoration(
                icon: const Icon(Icons.local_grocery_store),
                hintText: 'Enter the aisle',
                labelText: 'Aisle',
              ),
            ),
            TextFormField(
              controller: quantity,
              decoration: const InputDecoration(
                icon: const Icon(Icons.shopping_bag),
                hintText: 'Enter quantity',
                labelText: 'Quantity',
              ),
            ),
            TextFormField(
                controller: productname,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.shopping_basket),
                  hintText: 'Enter name of product',
                  labelText: 'Product Name',
                )),
            TextFormField(
              controller: price,
              decoration: const InputDecoration(
                icon: const Icon(Icons.shopping_basket),
                hintText: 'Enter price',
                labelText: 'price',
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
                        .doc(widget.productid)
                        .set({
                      "aisle": aisle.text,
                      "name": productname.text,
                      "quantity": int.parse(quantity.text),
                      "price": price.text
                    });
                    AddPicture concretePictureClass =
                        AddPicture(key: widget.productid);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => concretePictureClass));
                  },
                )),
          ],
        ),
      ),
    );
  }
}
