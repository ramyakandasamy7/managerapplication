import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
// For File Upload To Firestore
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'abstract_class.dart';
import 'add_product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker

class AddPictureMobile extends StatefulWidget implements AddPicture {
  final String barcode;
  AddPictureMobile(this.barcode, {Key key}) : super(key: key);
  @override
  AddPictureState createState() {
    return AddPictureState();
  }

  @override
  set barcode(String _barcode) {
    // TODO: implement barcode
  }

  @override
  deletePicture(String item) {
    // TODO: implement deletePicture
    StorageReference storageReference =
        FirebaseStorage(storageBucket: "gs://store-images-storage-1")
            .ref()
            .child('SLJ0i3hJMg8fNvCwdLOY/product_images/$item.jpg');
    storageReference.delete();
  }
}

AddPicture getPictureClass(String key) => AddPictureMobile(key);

class AddPictureState extends State<AddPictureMobile> {
  String _uploadedFileURL;
  PickedFile imaged;
  io.File _image;
  final _picker = ImagePicker();
  Future uploadFile() async {
    //FirebaseStorage.instance.g

    StorageReference storageReference =
        FirebaseStorage(storageBucket: "gs://store-images-storage-1")
            .ref()
            .child('SLJ0i3hJMg8fNvCwdLOY/product_images/${widget.barcode}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  //return _uploadedFileURL;

  Future chooseFile() async {
    await _picker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = io.File(image.path);
      });
    });
  }

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Picture Uploaded'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Your picture has been uploaded successfully!'),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReceiptForm2()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      (_image != null)
          ? Image.asset(
              _image.path,
              height: 150,
            )
          : Container(height: 150),
      Text("Upload Product Image"),
      if (_image == null)
        RaisedButton(
          child: Text('Choose File'),
          onPressed: chooseFile,
          color: Colors.cyan,
        ),
      Padding(
        padding: const EdgeInsets.all(20),
        child: RaisedButton(
          child: Text('No Image'),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ReceiptForm2()));
          },
          color: Colors.redAccent,
        ),
      ),
      if (_image != null && _uploadedFileURL == null)
        RaisedButton(
          child: Text('Upload File'),
          onPressed: () {
            uploadFile().then((value) => _showcontent());
            ;
          },
          color: Colors.cyan,
        ),
    ]));
  }
}
