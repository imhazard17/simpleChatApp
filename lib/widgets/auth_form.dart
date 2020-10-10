import 'dart:io';
import 'package:flutter/material.dart';
import 'user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function({
    @required String email,
    @required String password,
    @required String username,
    @required bool isLogin,
    @required BuildContext ctx,
    @required File userImage,
  }) submitFunc;
  final bool isLoading;
  AuthForm(this.submitFunc, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _inputEmail, _inputUsername, _inputPassword;
  bool _isLogin = true;
  File _userImageFile;

  void _pickedImage(File image) => _userImageFile = image;

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
      ));
      return;
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.submitFunc(
        email: _inputEmail.trim(),
        username: _inputUsername == null ? null : _inputUsername.trim(),
        password: _inputPassword.trim(),
        userImage: _userImageFile,
        isLogin: _isLogin,
        ctx: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  autocorrect: false,
                  validator: (value) => value.isEmpty || !value.contains('@')
                      ? 'Please provide a valid email address'
                      : null,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email address'),
                  onSaved: (newValue) => _inputEmail = newValue,
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    autocorrect: false,
                    validator: (value) => value.isEmpty || value.length < 4
                        ? 'Username should atleast be 4 charecters long'
                        : null,
                    decoration: InputDecoration(labelText: 'Username'),
                    onSaved: (newValue) => _inputUsername = newValue,
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  autocorrect: false,
                  validator: (value) => value.isEmpty || value.length < 7
                      ? 'Password should atleast be 7 charecters long'
                      : null,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (newValue) => _inputPassword = newValue,
                ),
                SizedBox(height: 12),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    child: Text(
                      _isLogin
                          ? 'Create new account'
                          : 'Login to an existing account',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                  ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
