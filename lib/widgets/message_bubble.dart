import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message, username, imageUrl;
  final bool isMe;
  final Key key;
  MessageBubble({
    @required this.message,
    @required this.isMe,
    @required this.key,
    @required this.username,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(!isMe ? 0 : 12),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                ),
              ),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                  Text(
                    message,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
