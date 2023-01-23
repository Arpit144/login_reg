import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_reg/screens/home_screen.dart';
import 'registration_screen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {


  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {


    final emailfield = TextFormField(
      controller: emailController,
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
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.redAccent,
      ),
      onSaved: (value) {
        emailController.text = value!;
      },
    );

    final passwordfield = TextFormField(
      controller: passwordController,
      autofocus: false,
      keyboardType: TextInputType.text,
      obscureText: true,
      obscuringCharacter: '*',
      textInputAction: TextInputAction.done,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
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
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.redAccent,
      ),
      onSaved: (value) {
        passwordController.text = value!;
      },
    );

    final loginbutton = ElevatedButton(onPressed: () {
      signIn(emailController.text, passwordController.text);
    },
      child: Text('Login', style: TextStyle(fontSize: 20,)),

    );

    return Scaffold(
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
                    Image.asset('assets/logo.png', width: 200),
                    emailfield,
                    SizedBox(height: 30,),
                    passwordfield,
                    SizedBox(height: 30,),
                    SizedBox(width: 200,
                      child: loginbutton,),
                    SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an Account ? "),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),));
                          },
                          child: Text('SignUp', style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent),),
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

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) =>
      {
        Fluttertoast.showToast(msg: "Login Successfully"),
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Homescreen())),
      }).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}