import './model/user.dart';

import './socket_utils.dart';

class G {
  static List<User> dummyUsers;

  static User loggedInUser;

  static User toChatUser;

  static SocketUtils socketUtils;

  static void initDummyUsers(){
    User userA = User(id: 1, name: 'A', email: 'test@gmail.com');
    User userB = User(id: 2, name: 'B', email: 'test123@gmail.com');

    dummyUsers = List();
    dummyUsers.add(userA);
    dummyUsers.add(userB);
  }

  static List<User> getUsersFor(User user){
    List<User> filteredUser = dummyUsers.where(
      (u) => (!u.name.toLowerCase().contains(user.name.toLowerCase()))
    ).toList();

    return filteredUser;
  }

  static initSocket() {
    if(socketUtils == null){
      socketUtils = SocketUtils();
    }
  }
}