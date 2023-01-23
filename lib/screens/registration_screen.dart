import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_reg/screens/home_screen.dart';
import 'package:login_reg/screens/login_screen.dart';

import '../models/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  final fullnameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmpasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final fullnamefield = TextFormField(
      controller: fullnameEditingController,
      autofocus: false,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Full Name is required for Registration");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name(Min 3 Character)");
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        contentPadding: EdgeInsets.all(20),
        hintText: 'Enter Your Full Name',
        labelText: 'Full Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.redAccent,
      ),
      onSaved: (value){
        fullnameEditingController.text = value!;
      },
    );

    final emailfield = TextFormField(
      controller: emailEditingController,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email Address");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a valid Email");
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
        contentPadding: EdgeInsets.all(20),
        hintText: 'Enter Your Email Address',
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.redAccent,
      ),
      onSaved: (value){
        emailEditingController.text = value!;
      },
    );

    final passwordfield = TextFormField(
      controller: passwordEditingController,
      autofocus: false,
      keyboardType: TextInputType.text,
      obscureText: true,
      obscuringCharacter: '*',
      textInputAction: TextInputAction.next,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for Registration");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min 6 Character)");
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.all(20),
        hintText: 'Enter Your Password',
        labelText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.redAccent,
      ),
      onSaved: (value){
        passwordEditingController.text = value!;
      },
    );

    final confirmpasswordfield = TextFormField(
      controller: confirmpasswordEditingController,
      autofocus: false,
      keyboardType: TextInputType.text,
      obscureText: true,
      obscuringCharacter: '*',
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (passwordEditingController.text != confirmpasswordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.all(20),
        hintText: 'Confirm Your Password',
        labelText: 'Confirm Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.redAccent,
      ),
      onSaved: (value){
        confirmpasswordEditingController.text = value!;
      },
    );

    final signupbutton = ElevatedButton(onPressed: () {

      signUp(emailEditingController.text, passwordEditingController.text);
    }
    ,child: Text('Sign Up',style: TextStyle(fontSize: 20,)),);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined,color: Colors.redAccent,size: 35,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png',width: 200),
                    fullnamefield,
                    SizedBox(height: 30,),
                    emailfield,
                    SizedBox(height: 30,),
                    passwordfield,
                    SizedBox(height: 30,),
                    confirmpasswordfield,
                    SizedBox(height: 30,),
                    SizedBox(width: 200,
                      child: signupbutton,
                    ),
                    SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an Account ? "),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen(),));
                          },
                          child: Text('Login',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.redAccent),),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void signUp(String email,String password) async{
    if(_formkey.currentState!.validate()){}
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {
          postDetailsToFirestore()})
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message);
    });
  }
  postDetailsToFirestore() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullnameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Homescreen()),
            (route) => false);
  }
}
