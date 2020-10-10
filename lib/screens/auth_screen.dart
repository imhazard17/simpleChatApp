import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm({
    @required String email,
    @required String password,
    @required String username,
    @required bool isLogin,
    @required BuildContext ctx,
    @required File userImage,
  }) async {
    AuthResult authResult;
    setState(() => _isLoading = true);
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        StorageReference ref = FirebaseStorage.instance
            .ref()
            .child('user_image/' + authResult.user.uid + '.jpg');
        await ref.putFile(userImage).onComplete;
        String url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'password😈': password,
          'imageUrl': url,
        });
      }
    } on PlatformException catch (err) {
      String errMessage = 'An error occured, please check yout credentials!';
      Scaffold.of(ctx).showSnackBar(
        SnackBar(content: Text(err.message ?? errMessage)),
      );
      setState(() => _isLoading = false);
    } catch (err) {
      print(err);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
