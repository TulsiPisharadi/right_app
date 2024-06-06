import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:right_app/Status.dart'; // Import the cloud_firestore package
import 'package:flutter_gemini/flutter_gemini.dart';

class GrievancePage extends StatefulWidget {
  @override
  _GrievancePageState createState() => _GrievancePageState();
}

class _GrievancePageState extends State<GrievancePage> {
  final TextEditingController _textController = TextEditingController();
  final Gemini gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grievance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit here your issues',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '* Please try to attach documents if you have more evidence.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Type here...',
                border: OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        // Handle camera functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {
                        // Handle voice recording functionality
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {
                        // Handle attachment functionality
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Submit the grievance text to Firebase
                _submitGrievance();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitGrievance() async {
    final grievanceText = _textController.text.trim();

    final Map<String, List<String>> department = {
      'Police': ['Inspector', 'Constable', 'SI'],
      'Fireforce': ['Firefighter', 'Fire Chief', 'Fire Inspector'],
      'Local Govt.': ['Mayor', 'Councilor', 'Administrator', 'Clerk'],
      'PWD': ['Engineer', 'Supervisor', 'Worker'],
      'Water Authority': ['Technician', 'Engineer', 'Manager'],
      'KSEB': ['Technician', 'Engineer', 'Manager'],
    };
    String question =
        'The user is giving the problem / instruction faced by him ; given the list of departments available $department select the most appropriate department and the proper authority to handle this issue(eg. If a technician is taking bribe, the report should be given to the higher authority; if no higher authority is found; report to police) and return the name of the department and position in the format ["Department","Position"] only.\n\n  the complaint is ${grievanceText}';

    var result = await gemini.text(question);
    String? outputText = result!.content!.parts!.first!.text;
    print(outputText);
    List<String> dataFromGemini =
        json.decode(outputText!).cast<String>().toList();
    print(dataFromGemini);

    if (grievanceText.isNotEmpty) {
      try {
        // Add the grievance text to Firestore
        await FirebaseFirestore.instance.collection('grievances').add({
          'text': grievanceText,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': getCurrentUserId(),
          'office': dataFromGemini[0],
          'position': dataFromGemini[1]
        });
        // Clear the text field after successful submission
        _textController.clear();
        // Show a success message or perform any additional actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Grievance submitted successfully to ${dataFromGemini[0]} ${dataFromGemini[1]}'),
          ),
        );
      } catch (e) {
        // Show an error message if submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit grievance'),
          ),
        );
      }
    }
  }
}
