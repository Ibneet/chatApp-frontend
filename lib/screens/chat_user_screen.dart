import 'package:flutter/material.dart';

import '../model/user.dart';
import '../global.dart';

class ChatUserScreen extends StatefulWidget {
  static const routeName = '/chat-user';

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  List<User> _chatUsers;
  bool _connectedToSocket;
  String _connectMessage;

  @override
  void initState(){
    _chatUsers = G.getUsersFor(G.loggedInUser);
    _connectedToSocket = false;
    _connectMessage = 'Connecting...';
    _connectToSocket();
    super.initState();
  }

  @override
  void dispose(){
    G.socketUtils.closeConnection();
    super.dispose();
  }

  _connectToSocket() async {
    print('Connecting logged in user ${G.loggedInUser.name}');
    G.initSocket();
    await G.socketUtils.initSocket(G.loggedInUser);
    G.socketUtils.connectToSocket();
    G.socketUtils.setOnConnectListener(onConnect);
    G.socketUtils.setOnConnectionTimeOutListener(onConnectionTimeout);
    G.socketUtils.setOnConnectionErrorListener(onConnectionError);
    G.socketUtils.setOnErrorListener(onError);
    G.socketUtils.setOnDisconnectListener(onDisConnect);
  }

  onConnect(data){
    print('Connected $data');
    setState(() {
      _connectedToSocket = true;
      _connectMessage = 'Connected';
    });
  }

  onConnectionTimeout(data){
    print('onConnectionTimeout $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection time out';
    });
  }

  onConnectionError(data){
    print('onConnectionError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection error';
    });
  }

  onError(data){
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Connection Error';
    });
  }

  onDisConnect(data){
    print('onDisConnect $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Disconnected';
    });
  }

  void _openChatScreen() {
    Navigator.of(context).pushNamed('/chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat users'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Text(_connectedToSocket ? 'Connected' : _connectMessage),
            Expanded(
              child: ListView.builder(
                itemCount: _chatUsers.length,
                itemBuilder: (context, index){
                  User user = _chatUsers[index];
                  return ListTile(
                    onTap: (){
                      G.toChatUser = user;
                      _openChatScreen();
                    },
                    title: Text(user.name),
                    subtitle: Text('Email ${user.email}'),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}