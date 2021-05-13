import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'add_product_manually.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'add_product_barcode.dart';
import 'package:flutter_gentelella/constants/page_titles.dart';
import 'package:flutter_gentelella/widgets/app_scaffold.dart';
import 'abstract_class.dart';

class ReceiptForm2 extends StatefulWidget {
  ReceiptForm2({Key key}) : super(key: key);

  @override
  _ReceiptForm2State createState() => _ReceiptForm2State();
}

class _ReceiptForm2State extends State<ReceiptForm2> {
  final firestoreInstance = cf.FirebaseFirestore.instance;
  String barcode = "";
  @override
  Widget build(BuildContext context) {
    Future<void> scanBarcode() async {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.BARCODE);
      print("PRODUCT BARCODE: ${barcode}");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyCustomFormBarcode(productid: barcode)));
      //return barcodeScanRes;
    }

    return AppScaffold(
        pageTitle: PageTitles.add_product,
        //appBar: AppBar(
        //  title: Text("Inventory"),
        //),
        body: StreamBuilder<QuerySnapshot>(
            // <2> Pass `Stream<QuerySnapshot>` to stream
            stream: FirebaseFirestore.instance
                .collection('SLJ0i3hJMg8fNvCwdLOY')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // <3> Retrieve `List<DocumentSnapshot>` from snapshot
                final List<DocumentSnapshot> documents = snapshot.data.docs;

                return Container(
                    child: SingleChildScrollView(
                        child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyCustomForm()));
                            },
                            child: Text('Add A New Product Manually')),
                        TextButton(
                            onPressed: () {
                              scanBarcode();
                            },
                            child: Text('Add with Barcode')),
                      ]),
                  SizedBox(height: 40),
                  Table(
                    children: [
                      TableRow(children: [
                        Center(
                            child: Text("Quantity",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                        Center(
                            child: Text("Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                        Center(
                            child: Text("Aisle",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                        Center(
                            child: Text("Price",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                        Center(
                            child: Text("Edit",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                        Center(
                            child: Text("Delete",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20))),
                      ]),
                    ],
                  ),
                  SizedBox(height: 20),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    children: documents
                        .map((item) => TableRow(children: [
                              Text(
                                item['quantity'].toString(),
                                style: new TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                item['name'].toString(),
                                style: new TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                item['aisle'].toString(),
                                style: new TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                item['price'].toString(),
                                style: new TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialog(context, item),
                                    );
                                  },
                                  child: Text('Edit')),
                              TextButton(
                                  onPressed: () async {
                                    firestoreInstance
                                        .collection('SLJ0i3hJMg8fNvCwdLOY')
                                        .doc(item.id)
                                        .delete();
                                    AddPicture concretePictureClass =
                                        AddPicture(key: item.id);
                                    await concretePictureClass
                                        .deletePicture(item.id);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReceiptForm2()));
                                  },
                                  child: Text('Delete'))
                            ]))
                        .toList(),
                  )
                ])));
              } else if (snapshot.hasError) {
                return Text('Its Error!');
              }
              if (!snapshot.hasData) {
                print('test phrase');
                return Text("Loading.....");
              } else {
                return Text('Blank');
              }
            }));
  }
}

Widget _buildPopupDialog(BuildContext context, DocumentSnapshot item) {
  final firestoreInstance = cf.FirebaseFirestore.instance;
  TextEditingController aisle =
      TextEditingController(text: item['aisle'].toString());
  TextEditingController quantity =
      TextEditingController(text: item['quantity'].toString());
  TextEditingController productname =
      TextEditingController(text: item['name'].toString());
  TextEditingController price =
      TextEditingController(text: item['price'].toString());
  return new AlertDialog(
    title: const Text('Popup example'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
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
        TextButton(
            onPressed: () {
              AddPicture concretePictureClass = AddPicture(key: item.id);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => concretePictureClass));
            },
            child: Text('Modify Picture')),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
      new FlatButton(
          onPressed: () {
            firestoreInstance
                .collection('SLJ0i3hJMg8fNvCwdLOY')
                .doc(item.id)
                .set({
              "aisle": aisle.text,
              "name": productname.text,
              "quantity": int.parse(quantity.text),
              "price": price.text
            });
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ReceiptForm2()),
            );
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Submit'))
    ],
  );
}
