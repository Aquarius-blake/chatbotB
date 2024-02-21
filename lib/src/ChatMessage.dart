import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color bottextcolor;
  final Color usertextcolor;
  final DateTime messageTime;
  final Color botColor;
  final Color userColor;
  final Icon botIcon;
  final Icon userIcon;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    required this.messageTime,
    required this.botIcon,
    required this.usertextcolor,
    required this.bottextcolor,
    required this.userIcon,
    required this.botColor,
    required this.userColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUser)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: userColor,
                    radius: 20.0,
                    child: botIcon,
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isUser ? userColor : botColor,
                  borderRadius: isUser
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                ),
                child: Text(
                  text,
                  style:  TextStyle(
                    color: isUser ? usertextcolor : bottextcolor,
                    ),
                ),
              ),
              if (isUser)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: userColor,
                    radius: 20.0,
                    child: userIcon,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
            "${messageTime.hour}:${messageTime.minute}:${messageTime.second}",
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
