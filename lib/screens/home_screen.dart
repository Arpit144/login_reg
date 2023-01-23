import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_reg/screens/login_screen.dart';

import '../models/user_model.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome'),centerTitle: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png',width: 200,),
            Text("Welcome Back",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            Text("${loggedInUser.fullName}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            Text("${loggedInUser.email}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  logout(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    Text('Logout')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Loginscreen()));
  }
}
