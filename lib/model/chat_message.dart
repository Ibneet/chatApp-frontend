import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
    ChatMessage({
        this.chatId,
        this.from,
        this.to,
        this.message,
        this.chatType,
        this.toUserOnlineStatus,
        this.isFromMe
    });

    String chatId;
    String from;
    String to;
    String message;
    String chatType;
    bool toUserOnlineStatus;
    bool isFromMe;

    factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        chatId: json["chat_id"],
        from: json["from"],
        to: json["to"],
        message: json["message"],
        chatType: json["chat_type"],
        toUserOnlineStatus: json["to_user_online_status"],
    );

    Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "from": from,
        "to": to,
        "message": message,
        "chat_type": chatType,
        "to_user_online_status": toUserOnlineStatus,
    };
}