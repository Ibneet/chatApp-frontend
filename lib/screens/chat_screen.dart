import 'dart:async';

import 'package:flutter/material.dart';

import '../model/chat_message.dart';
import '../model/user.dart';
import '../global.dart';
import '../widgets/chat_title.dart';
import '../socket_utils.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatScreen> {
  List<ChatMessage> _chatMessages;
  User _toChatUser;
  UserOnlineStatus _userOnlineStatus;

  TextEditingController _chatTextController;
  ScrollController _chatListController;

  @override
  void setState(fn){
    if(mounted){
      super.setState((fn));
    }
  }

  @override
  void initState() {
    _chatMessages = List();
    _toChatUser = G.toChatUser;
    _chatTextController = TextEditingController();
    _chatListController = ScrollController(initialScrollOffset: 0);
    _userOnlineStatus = UserOnlineStatus.connecting;
    _initSocketListener();
    _checkOnline();
    super.initState();
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  _checkOnline(){
    ChatMessage chatMessage = ChatMessage(
      chatId: 0,
      from: G.loggedInUser.id,
      to: _toChatUser.id,
      toUserOnlineStatus: false,
      message: '',
      chatType: SocketUtils.SINGLE_CHAT
    );
    G.socketUtils.checkOnline(chatMessage);
  }

  _initSocketListener() async {
    G.socketUtils.setOnChatMessageReceiveListener(onChatMessageReceived);
    G.socketUtils.setOnlineUserStatusListener(onUserStatus);
  }

  _removeListeners() async {
    G.socketUtils.setOnChatMessageReceiveListener(null);
    G.socketUtils.setOnlineUserStatusListener(null);
  }

  onUserStatus(data) {
    print('onUserStatus $data');
    ChatMessage chatMessage = ChatMessage.fromJson(data);
    setState(() {
      _userOnlineStatus = chatMessage.toUserOnlineStatus 
        ? UserOnlineStatus.online 
        : UserOnlineStatus.offline;
    });
  }

  onChatMessageReceived(data) {
    print('onChatMessageReceived $data');
    ChatMessage chatMessage = ChatMessage.fromJson(data);
    chatMessage.isFromMe = false;
    processMessage(chatMessage);
    _chatListScrollToBottom();
  }

  processMessage(chatMessage) {
    setState(() {
      _chatMessages.add(chatMessage);
    });
  }

  _chatListScrollToBottom() {
    Timer(
      Duration(milliseconds: 100), (){
        if(_chatListController.hasClients){
          _chatListController.animateTo(
            _chatListController.position.maxScrollExtent, 
            duration: Duration(milliseconds: 100), 
            curve: Curves.decelerate
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatTitle(
          toChatUser: _toChatUser,
          userOnlineStatus: _userOnlineStatus,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _chatListController,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index){
                  ChatMessage chatMessage = _chatMessages[index];
                  bool fromMe = chatMessage.isFromMe;
                  return Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    alignment: 
                      fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    color: fromMe ? Colors.green : Colors.grey,
                    child: Text(chatMessage.message)
                  );
                }
              ),
            ),
            _bottomChatArea()
          ],
        ),
      ),
    );
  }


  _bottomChatArea() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessageBtnTap();
            },
          )
        ],
      ),
    );
  }

  _sendMessageBtnTap() async {
    print('${_toChatUser.name}');
    if(_chatTextController.text.isEmpty){
      return;
    }
    ChatMessage chatMessage = ChatMessage(
      chatId: 0,
      from: G.loggedInUser.id,
      to: _toChatUser.id,
      toUserOnlineStatus: false,
      message: _chatTextController.text,
      chatType: SocketUtils.SINGLE_CHAT, 
      isFromMe: true
    );
    processMessage(chatMessage);
    G.socketUtils.sendSingleChatMessage(chatMessage);
    _chatListScrollToBottom();
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _chatTextController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(10),
          hintText: 'Type message'
        ),
      ),
    );
  }
}


