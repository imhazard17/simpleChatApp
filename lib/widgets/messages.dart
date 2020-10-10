import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting)
          return Center(child: Container(child: CircularProgressIndicator()));
        FirebaseUser user = futureSnapshot.data;
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            List<DocumentSnapshot> chatDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) => MessageBubble(
                  message: chatDocs[index]['text'],
                  isMe: chatDocs[index]['userID'] == user.uid,
                  key: ValueKey(chatDocs[index].documentID),
                  username: chatDocs[index]['username'],
                  imageUrl: chatDocs[index]['userImage']),
            );
          },
        );
      },
    );
  }
}

// <String>() async {
//                     FirebaseUser user =
//                         await FirebaseAuth.instance.currentUser();
//                     return user.uid;
//                   }
