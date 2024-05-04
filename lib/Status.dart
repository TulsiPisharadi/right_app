import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grievances')
            .where('userId', isEqualTo: getCurrentUserId())
            .snapshots(),
        builder: (context, grievancesSnapshot) {
          if (grievancesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (grievancesSnapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${grievancesSnapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            itemCount: grievancesSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              print('Index: $index');
              print('Length: ${grievancesSnapshot.data!.docs.length}'
                  ' ${grievancesSnapshot.data!.docs}');
              // The snapshot contains a collection called replies which doc corresponding to each reply, each reply has a text and a timestamp

              final grievanceDoc = grievancesSnapshot.data!.docs[index];
              final grievanceData = grievanceDoc.data() as Map<String, dynamic>;

              final officerReplies = grievanceDoc.reference
                  .collection('replies')
                  .orderBy('timestamp', descending: true)
                  .snapshots();

              return StreamBuilder<QuerySnapshot>(
                stream: officerReplies,
                builder: (context, repliesSnapshot) {
                  if (repliesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (repliesSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${repliesSnapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final replies = repliesSnapshot.data!.docs;
                  final grievanceText = grievanceData['text'];
                  final grievanceTimestamp =
                      grievanceData['timestamp'].toDate();

                  final officerReplies = replies
                      .map((reply) => reply.data() as Map<String, dynamic>)
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: officerReplies.length,
                    itemBuilder: (context, index) {
                      final replyData = officerReplies[index];
                      final officerReply = replyData['text'];
                      final officerReplyTimestamp =
                          replyData['timestamp'].toDate();

                      return StatusBox(
                        text: grievanceText,
                        timestamp: grievanceTimestamp,
                        officerReply: officerReply,
                        officerReplyTimestamp: officerReplyTimestamp,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class StatusBox extends StatelessWidget {
  final String text;
  final DateTime timestamp;
  String? officerReply;
  DateTime? officerReplyTimestamp;

  StatusBox({
    required this.text,
    required this.timestamp,
    this.officerReply,
    this.officerReplyTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Submitted on: ${timestamp.toString()}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Builder(builder: (context) {
            if (officerReply == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Officer\'s Reply:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  officerReply!,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Replied on: ${officerReplyTimestamp.toString()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

String getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    // Handle the case when the user is not logged in
    return '';
  }
}
