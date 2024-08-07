import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'data:image/jpeg;base64,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'),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        print("Edit Pic");
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'John Doe',
                style: TextStyle(
                    color: const Color.fromARGB(255, 2, 2, 2),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'john@gmail.com',
                style: TextStyle(
                    color: const Color.fromARGB(255, 105, 105, 105),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
         
              SizedBox(
                height: 30,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(172, 223, 216, 216)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      print("Press");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: 25,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Update Profile',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(172, 223, 216, 216)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      print("Press");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.add_business,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: 20,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Orders History',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color.fromARGB(255, 0, 0, 0)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () {
                      print("Press");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Color.fromARGB(255, 250, 250, 250),
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.logout,
                          color: Color.fromARGB(255, 248, 248, 248),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
