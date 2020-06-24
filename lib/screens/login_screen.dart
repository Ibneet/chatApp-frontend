import 'package:flutter/material.dart';

import '../model/user.dart';
import '../global.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _userController;

  @override
  void initState() {
    _userController = TextEditingController();
    G.initDummyUsers();
    super.initState();
  }

  void _onLogin(){
    if(_userController.text.isEmpty){
      return;
    }
    User me = G.dummyUsers[0];
    if(_userController.text != 'a'){
      me = G.dummyUsers[1];
    }
    G.loggedInUser = me; 

    Navigator.of(context).pushReplacementNamed('/chat-user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _userController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            SizedBox(height: 20,),
            OutlineButton(
              child: Text('Login'),
              onPressed: _onLogin,
            )
          ],
        ),
      ),
    );
  }
}
