import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:right_app/AboutUs.dart';
import 'package:right_app/Grievance.dart';
import 'package:right_app/Profile.dart';
import 'package:right_app/Status.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set the Scaffold background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the AppBar color to white
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.black), // Set the back button color to black
          onPressed: () {
            // Handle back button press
          },
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home,
                  color: Colors.black), // Set the home icon color to black
              SizedBox(width: 8),
              Text(
                'The Right',
                style: TextStyle(
                    color: Colors.black), // Set the title text color to black
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,
                color:
                    Colors.black), // Set the notification icon color to black
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GrievancePage()),
                    );
                  },
                  child: MenuButton(
                    icon: Icons.message,
                    text: 'Grievances',
                    color: Colors.white, // Set the button color to white
                    iconColor: Colors.black, // Set the icon color to black
                    size: 150,
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatusPage()),
                    );
                  },
                  child: MenuButton(
                    icon: Icons.check_circle,
                    text: 'Status',
                    color: Colors.white, // Set the button color to white
                    iconColor: Colors.black, // Set the icon color to black
                    size: 150,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  child: MenuButton(
                    icon: Icons.person,
                    text: 'Profile',
                    color: Colors.white, // Set the button color to white
                    iconColor: Colors.black, // Set the icon color to black
                    size: 150,
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutUsScreen()),
                    );
                  },
                  child: MenuButton(
                    icon: Icons.info,
                    text: 'About Us',
                    color: Colors.white, // Set the button color to white
                    iconColor: Colors.black, // Set the icon color to black
                    size: 150,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  final double size;

  MenuButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.iconColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color, // Set the container color to the provided color
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(
                    0.5), // Set the shadow color to grey with opacity
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor, // Set the icon color to the provided color
            size: size / 3, // Adjust the icon size based on the button size
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.black, // Set the text color to black
            fontSize: 16, // Increase the text size slightly
          ),
        ),
      ],
    );
  }
}
