import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) {
            return MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['userId'] == user.uid,
              chatDocs[index]['username'],
              chatDocs[index]['userImage'],
            );
          },
          itemCount: chatDocs.length,
        );
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('timestamp', descending: true)
          .snapshots(),
    );
  }
}
