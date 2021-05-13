import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'add_product.dart';

class Product {
  String aisle;
  String name;
  String price;
  String barcodeid;
  String quantity;

  Product({this.aisle, this.name, this.price, this.quantity, this.barcodeid});
}

class MyModifyForm extends StatefulWidget {
  //MyCustomForm({Key key, this.productid}) : super(key: key);
  @override
  MyModifyFormState createState() {
    return MyModifyFormState();
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyModifyFormState extends State<MyModifyForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = cf.FirebaseFirestore.instance;
  TextEditingController aisle = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController productname = TextEditingController();
  TextEditingController barcodeid = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return new Scaffold(
      appBar: AppBar(title: Text("Create a New Inventory Item")),
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
              controller: barcodeid,
              decoration: const InputDecoration(
                icon: const Icon(Icons.local_grocery_store),
                hintText: 'Enter the barcode or product id',
                labelText: 'barcode',
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
              controller: price,
              decoration: const InputDecoration(
                icon: const Icon(Icons.shopping_bag),
                hintText: 'Enter price',
                labelText: 'price',
              ),
            ),
            TextFormField(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReceiptForm2()));
                  },
                )),
          ],
        ),
      ),
    );
  }
}
