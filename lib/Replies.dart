import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RepliesPage extends StatefulWidget {
  @override
  _RepliesPageState createState() => _RepliesPageState();
}

class _RepliesPageState extends State<RepliesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Replies'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('grievances').snapshots(),
        builder: (context, grievancesSnapshot) {
          if (grievancesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (grievancesSnapshot.hasError) {
            return Center(child: Text('Error: ${grievancesSnapshot.error}'));
          }

          return ListView.builder(
            itemCount: grievancesSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final grievanceDoc = grievancesSnapshot.data!.docs[index];
              final grievanceData =
                  grievanceDoc.data() as Map<String, dynamic>?;

              return GrievanceCard(
                grievanceText: grievanceData?['text'] ?? '',
                grievanceTimestamp:
                    grievanceData?['timestamp'].toDate() ?? DateTime.now(),
                grievanceId: grievanceDoc.id,
              );
            },
          );
        },
      ),
    );
  }
}

class GrievanceCard extends StatefulWidget {
  final String grievanceText;
  final DateTime grievanceTimestamp;
  final String grievanceId;

  GrievanceCard({
    required this.grievanceText,
    required this.grievanceTimestamp,
    required this.grievanceId,
  });

  @override
  _GrievanceCardState createState() => _GrievanceCardState();
}

class _GrievanceCardState extends State<GrievanceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
            'Grievance:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.grievanceText,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Submitted on: ${widget.grievanceTimestamp.toString()}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 16),
          Text(
            'Replies:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('grievances')
                  .doc(widget.grievanceId)
                  .collection('replies')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, repliesSnapshot) {
                if (repliesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (repliesSnapshot.hasError) {
                  return Center(child: Text('Error: ${repliesSnapshot.error}'));
                }

                if (repliesSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No replies yet.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: repliesSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final replyData = repliesSnapshot.data!.docs[index].data()
                        as Map<String, dynamic>?;
                    final replyText = replyData?['text'] ?? '';
                    final replyTimestamp =
                        replyData?['timestamp'].toDate() ?? DateTime.now();

                    return Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replyText,
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Replied on: ${replyTimestamp.toString()}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
