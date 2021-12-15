import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metrkoin/screens/homepage/homepage.dart';
import 'package:metrkoin/services/auth.dart';
import 'package:metrkoin/utils/app_bar.dart';
import 'package:metrkoin/utils/buttons.dart';
import 'package:metrkoin/utils/colors.dart';
import 'package:metrkoin/utils/metrkoin_logo.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String _username = '';
  String _refCode = '';
  String bySigningUp = 'By signing up, I agree to the privacy policy and terms of service of MetrKoin';
  File _imageFile;

  bool _isError = false;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    AuthServices _auth = new AuthServices();

    return Scaffold(
      appBar: AppBarWidget(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
        color: colorWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    child: _imageFile==null ? Image.asset("assets/images/profile_image.png")
                        : Image.file(_imageFile, fit: BoxFit.fill,),
                  ),
                  onTap: () => _imagePickerDialog(context),
                ),
                Spacer(flex: 1),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: Text("Username", style: TextStyle(fontSize: 17.0, color: colorBlack),)),
            TextFormField(
              maxLines: 1,
              autofocus: false,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  hintText: "MetrKoin User", hintStyle: TextStyle(fontSize: 14.0)),
              onSaved: (value) => _username = value.trim(),
              style: TextStyle(fontSize: 14.0),
              onChanged: (value) {
                setState(() {
                  _username = value;
                  _isError = false;
                });
              },
            ),
            Text(_isError ? 'username is required!' : '', style: TextStyle(color: colorRed, fontSize: 12.0),),
            Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Text("Referral code", style: TextStyle(fontSize: 17.0, color: colorBlack),)),
            TextFormField(
              maxLines: 1,
              autofocus: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "hy40hw6M", hintStyle: TextStyle(fontSize: 14.0)),
              onSaved: (value) => _refCode = value.trim(),
              style: TextStyle(fontSize: 14.0),
              onChanged: (value) {
                setState(() => _refCode = value );
              },
            ),
            Spacer(flex: 1),
            Text(bySigningUp, style: TextStyle(fontSize: 14.0), textAlign: TextAlign.center,),
            SizedBox(height: 8.0,),

            DefaultButtonPurple('Sign up with Google', () async {
              if (_username.isNotEmpty) {
                setState(() => _isLoading = true);
                dynamic user = await _auth.signUpWithGoogle();
                if (user != null) {
                  Get.off(HomePage());
                }
                else if (user == null) {
                  setState(() => _isLoading = false);
                }
              } else {
                setState(() => _isError = true);
              }
            })
          ],
        )
      ),
    );
  }

  Future _imagePickerDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: 160.0,
              child: Column(
                  children: <Widget>[
                    Text("Select image from",
                      style: TextStyle(fontSize: 18.0, color: colorPurpleLMain),),
                    Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            _getImageFomCamera();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_camera.jpeg", height: 46.0, width: 46.0,),
                              SizedBox(height: 5.0,),
                              Text("Camera", style: TextStyle(fontSize: 14.0),)
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _getImageFromGallery();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/images/image_gallery.png", height: 46.0, width: 46.0,),
                              SizedBox(height: 5.0,),
                              Text("Gallery", style: TextStyle(fontSize: 14.0),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          );
        }
    );
  }

  Future<void> _getImageFomCamera() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.camera);
    setState(() => _imageFile = File(_image.path));
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final _image = await picker.getImage(source: ImageSource.gallery);
    setState(() => _imageFile = File(_image.path));
  }


}
