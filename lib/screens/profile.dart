import 'dart:io';

import 'package:flutterapp/models/api_response.dart';
import 'package:flutterapp/models/user.dart';
import 'package:flutterapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  // Method to show the modal bottom sheet
void _showImagePickerModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

// Updated getImage method to accept source parameter
Future getImage(ImageSource source) async {
  final pickedFile = await _picker.getImage(source: source);
  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }
}

  // Future getImage() async {
  //   final pickedFile = await _picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  //update profile
  void updateProfile() async {
    ApiResponse response =
        await updateUser(txtNameController.text, getStringImage(_imageFile));
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                    child: GestureDetector(
                  child: Container(
                    width: 110,
                    height: 110,
                  ),
                )),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: kInputDecoration('Name'),
                    controller: txtNameController,
                    validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.black,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey, // change the button color to grey
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      updateProfile();
                    }
                  },
                )
              ],
            ),
          );
          
  }
}
