import 'dart:io';
import 'package:adhara_socket_io/adhara_socket_io.dart';

import './model/user.dart';
import './model/chat_message.dart';

class SocketUtils {
  static String _serverIp =
      Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2';
  static const int SERVER_PORT = 5000;
  static String _connectUrl = '$_serverIp:$SERVER_PORT';

  //Events
  static const String _ON_MESSAGE_RECEIVED = 'receive_message';
  static const String _IS_USER_ONLINE = 'check_online';
  static const EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';
  static const EVENT_USER_ONLINE = 'is_user_connected';

  //Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;

  //Type of chat
  static const String SINGLE_CHAT = 'single_chat';

  User _fromUser;

  SocketIO _socket;
  SocketIOManager _manager;

  initSocket(User fromUser) async {
    this._fromUser = fromUser;
    print('Connecting... ${fromUser.name}');
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  connectToSocket() {
    if(_socket == null){
      print('Socket is null');
      return;
    }
    _socket.connect();
  }

  _socketOptions(){
    final Map<String, String> userMap = {
      'from': _fromUser.id.toString(),
    };
    return SocketOptions(
      _connectUrl, 
      enableLogging: true,
      transports: [Transports.WEB_SOCKET],
      query: userMap
    );
  }

  setOnConnectListener(Function onConnect) {
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  setOnConnectionTimeOutListener(Function onConnectionTimeout) {
    _socket.onConnectTimeout((data) {
      onConnectionTimeout(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectionError) {
    _socket.onConnectError((data) {
      onConnectionError(data);
    });
  }

  setOnErrorListener(Function onError) {
    _socket.onError((data) {
      onError(data);
    });
  }

  setOnDisconnectListener(Function onDisConnect) {
    _socket.onDisconnect((data) {
      onDisConnect(data);
    });
  }

  closeConnection() {
    if(_socket != null) {
      print('Closing connection');
      _manager.clearInstance(_socket);
    }
  }

  sendSingleChatMessage(ChatMessage chatMessage) {
    if(_socket == null){
      print('Cannot send message.');
      return;
    }
    _socket.emit(EVENT_SINGLE_CHAT_MESSAGE, [chatMessage.toJson()]);
  }

  setOnChatMessageReceiveListener(Function onMessageReceived) {
    if(onMessageReceived == null){
      return;
    }
    _socket.on(_ON_MESSAGE_RECEIVED, (data) { 
      onMessageReceived(data);
    });
  }

  setOnlineUserStatusListener(Function onUserStatus) {
    if(onUserStatus == null){
      return;
    }
    _socket.on(EVENT_USER_ONLINE, (data) { 
      onUserStatus(data);
    });
  }

  checkOnline(ChatMessage chatMessage) {
    print('Checking Online User: ${chatMessage.to}');
    if(_socket == null){
      print('Cannot Check online.');
      return;
    }
    _socket.emit(_IS_USER_ONLINE, [chatMessage.toJson()]);
  }
}
