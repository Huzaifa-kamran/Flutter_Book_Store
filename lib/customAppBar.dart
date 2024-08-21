// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Color.fromARGB(255, 255, 253, 253),
//       leading: IconButton(
//         icon: Icon(Icons.menu, color: Colors.black),
//         onPressed: () {
//           Scaffold.of(context).openDrawer();
//         },
//       ),
//       actions: [
//         Padding(
//           padding: EdgeInsets.only(right: 20.0),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context)
//                   .pushNamed('/profile'); // Navigate to the profile screen
//             },
//             child: CircleAvatar(
//               backgroundImage: AssetImage("images/user2.jpg"),
//               radius: 20,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
