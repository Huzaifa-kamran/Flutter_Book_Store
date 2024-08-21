import 'package:bookstore/appstyle.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            Text(
              'User Profile',
              style: AppStyle.mainHeading(),
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'YOUR_IMAGE_URL_HERE', // Use a network URL or asset image
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      // Handle edit image
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text("User Name", style: AppStyle.subHeading()),
            SizedBox(height: 30),
            _buildActionButton(
              context,
              "Update Profile",
              () {
                // Handle update profile
              },
            ),
            SizedBox(height: 10),
            _buildActionButton(
              context,
              "My Orders",
              () {
                // Handle view orders
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text(
                'Logout',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}
