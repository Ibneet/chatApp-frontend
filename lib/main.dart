import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/chat_user_screen.dart';
import './screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {
        ChatUserScreen.routeName: (ctx) => ChatUserScreen(),
        ChatScreen.routeName: (ctx) => ChatScreen()
      },
    );
  }
}