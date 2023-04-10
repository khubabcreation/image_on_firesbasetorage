import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({super.key});

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool isloading = false;

  Future<void> uploadimage(String inputSource) async {
    final picker = ImagePicker();
    final XFile? pickedimage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery);

    if (pickedimage == null) {
      return null;
    }

    String fileName = pickedimage.name;
    File imageFile = File(pickedimage.path);
    try {
      setState(() {
        isloading = true;
      });
      await firebaseStorage.ref(fileName).putFile(imageFile);
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Successfully Uploaded')));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Future<List> loadImages() async {
  //   List<Map> files = [];
  //   final ListResult result = await firebaseStorage.ref().listAll();
  //   final List<Reference> allFiles = result.items;
  //   await Future.forEach(allFiles, (Reference file) async {
  //     final String fileUrl = await file.getDownloadURL();
  //     files.add({
  //       'url': fileUrl,
  //       'path': file.fullPath,
  //     });
  //   });
  //   print(files);
  //   return files;
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - kToolbarHeight;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Container(
          height: height,
          width: width,
          child: Column(
            children: [
              isloading
                  ? Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            uploadimage('camera');
                          },
                          icon: Icon(Icons.camera_enhance),
                          label: Text('camera'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            uploadimage('gallery');
                          },
                          icon: Icon(Icons.camera_enhance),
                          label: Text('gallery'),
                        ),
                      ],
                    ),
              SizedBox(
                height: height * 0.05,
              ),
              // Expanded(
              //     child: FutureBuilder(
              //   initialData: [],
              //   future: loadImages(),
              //   builder: (context, AsyncSnapshot snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     } else
              //       return ListView.builder(
              //         itemCount: snapshot.data.items.lenght,
              //         itemBuilder: (context, index) {
              //           final Map image = snapshot.data[index];
              //           return Row(
              //             children: [
              //               Expanded(
              //                   child: Card(
              //                 child: Container(
              //                   height: 200,
              //                   child: Image.network(image['url']),
              //                 ),
              //               ))
              //             ],
              //           );
              //         },
              //       );
              //   },
              // ))
            ],
          )),
    );
  }
}
