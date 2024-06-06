import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmissionsPage extends StatefulWidget {
  @override
  _SubmissionsPageState createState() => _SubmissionsPageState();
}

class _SubmissionsPageState extends State<SubmissionsPage> {
  final TextEditingController _replyController = TextEditingController();

  void _sendReply(String grievanceId, String reply) {
    // Add the reply to the 'replies' subcollection of the grievance document
    FirebaseFirestore.instance
        .collection('grievances')
        .doc(grievanceId)
        .collection('replies')
        .add({'text': reply, 'timestamp': FieldValue.serverTimestamp()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submissions'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('grievances').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final grievanceData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final grievanceId = snapshot.data!.docs[index].id;

              return SubmissionBox(
                text: grievanceData['text'],
                timestamp: grievanceData['timestamp'].toDate(),
                onReply: (reply) {
                  _sendReply(grievanceId, reply);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SubmissionBox extends StatefulWidget {
  final String text;
  final DateTime timestamp;
  final Function(String) onReply;

  SubmissionBox({
    required this.text,
    required this.timestamp,
    required this.onReply,
  });

  @override
  _SubmissionBoxState createState() => _SubmissionBoxState();
}

class _SubmissionBoxState extends State<SubmissionBox> {
  final TextEditingController _replyController = TextEditingController();

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
            widget.text,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Submitted on: ${widget.timestamp.toString()}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _replyController,
            decoration: InputDecoration(
              hintText: 'Reply...',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_replyController.text.isNotEmpty) {
                    widget.onReply(_replyController.text);
                    _replyController.clear();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
