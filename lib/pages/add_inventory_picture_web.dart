import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
// For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:universal_html/html.dart';
import 'package:image_picker_web/image_picker_web.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'abstract_class.dart';
import 'add_product.dart';

class AddPictureHTML extends StatefulWidget implements AddPicture {
  final String barcode;
  AddPictureHTML(this.barcode, {Key key}) : super(key: key);
  @override
  AddPictureHTMLState createState() {
    return AddPictureHTMLState();
  }

  @override
  set barcode(String _barcode) {
    // TODO: implement barcode
  }

  @override
  deletePicture(String item) {
    fb.StorageReference storageReference = fb
        .storage()
        .refFromURL("gs://store-images-storage-1")
        .child('SLJ0i3hJMg8fNvCwdLOY/product_images/$item' + ".jpg");
    storageReference.delete();
  }
}

AddPicture getPictureClass(String key) => AddPictureHTML(key);

class AddPictureHTMLState extends State<AddPictureHTML> {
  String _uploadedFileURL;
  MediaInfo mediaInfo;

  Future uploadFile() async {
    //FirebaseStorage.instance.g
    if (kIsWeb) {
      print("kisWeb");
      try {
        String mimeType = mime(Path.basename(mediaInfo.fileName));

        // html.File mediaFile =
        //     new html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});
        final String extension = extensionFromMime(mimeType);

        var metadata = fb.UploadMetadata(
          contentType: mimeType,
        );

        fb.StorageReference storageReference = fb
            .storage()
            .refFromURL("gs://store-images-storage-1")
            .child('SLJ0i3hJMg8fNvCwdLOY/product_images/${widget.barcode}' +
                ".jpg");
        fb.UploadTaskSnapshot uploadTaskSnapshot =
            await storageReference.put(mediaInfo.data, metadata).future;

        await uploadTaskSnapshot.ref.getDownloadURL().then((fileURL) {
          setState(() {
            _uploadedFileURL = fileURL.toString();
          });
        });
      } catch (e) {
        print("File Upload Error $e");
        return null;
      }
    }

    //return _uploadedFileURL;
    Future<Uri> uploadFileWeb(MediaInfo mediaInfo) async {
      try {
        String mimeType = mime(Path.basename(mediaInfo.fileName));

        // html.File mediaFile =
        //     new html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});
        final String extension = extensionFromMime(mimeType);

        var metadata = fb.UploadMetadata(
          contentType: mimeType,
        );

        fb.StorageReference storageReference = fb
            .storage()
            .refFromURL("gs://store-images-storage-1")
            .child('SLJ0i3hJMg8fNvCwdLOY/product_images/${widget.barcode}' +
                ".$extension");
        fb.UploadTaskSnapshot uploadTaskSnapshot =
            await storageReference.put(mediaInfo.data, metadata).future;

        Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        print("download url $imageUri");
        return imageUri;
      } catch (e) {
        print("File Upload Error $e");
        return null;
      }
    }
  }

  Future chooseFile() async {
    if (kIsWeb) {
      MediaInfo media = await ImagePickerWeb.getImageInfo;

      setState(() {
        mediaInfo = media;
      });
    }
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
    // TODO: implement build
    return Scaffold(
        body: Column(children: <Widget>[
      if (mediaInfo != null)
        Image.memory(
          mediaInfo.data,
          height: 150,
        ),
      Text("Upload Product Image"),
      if (mediaInfo == null)
        RaisedButton(
          child: Text('Choose File'),
          onPressed: () {
            chooseFile();
          },
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
      if (mediaInfo != null && _uploadedFileURL == null)
        RaisedButton(
          child: Text('Upload File'),
          onPressed: () {
            uploadFile().then((value) => _showcontent());
          },
          color: Colors.cyan,
        ),
    ]));
  }
}
