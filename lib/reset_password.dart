import 'package:expense_calculator/Signup_page.dart';
import 'package:expense_calculator/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'auth_controller.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been sent !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No user found for that email.',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor : Colors.white,
      body: Column(
        children:[
          Container(
              width: w,
              height: h*0.35,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "img/loginbtn.png"
                      ),
                      fit:BoxFit.cover
                  )
              ),
              child: Column(
                  children:[
                    SizedBox(height:h*0.16,),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      radius: 50,
                      backgroundImage: AssetImage(
                          "img/authentication.png"
                      ),
                    )
                  ]
              )
          ),
          Container(
              margin: const EdgeInsets.only(left:20,right:20),
              width:w,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:50,),
                  Container(
                    decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 7,
                              blurRadius:10,
                              offset: Offset(1,1),
                              color:Colors.grey.withOpacity(0.2)
                          )
                        ]
                    ),
                    child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText:"Email id",
                            prefixIcon:Icon(Icons.person,color:Colors.deepPurpleAccent),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color:Colors.white,
                                    width:1.0
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color:Colors.white,
                                    width:1.0
                                )
                            ),
                            border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              )
          ),
          RichText(text:TextSpan(
            text:"Mail will be sent to you email ID",
            style: TextStyle(
                color:Colors.grey[500],
                fontSize:17
            ),
          )
          ),
          SizedBox(height: 40,),
          GestureDetector(
            onTap:(){
                resetPassword();
            },
            child: Container(
              width: w*0.5,
              height: h*0.08,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage(
                          "img/loginbtn.png"
                      ),
                      fit:BoxFit.cover
                  )
              ),
              child: Center(
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height:10,),
          RichText(
              text:TextSpan(
                  recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                  text:"Remmember your password?",
                  style:TextStyle(
                      fontSize:20,
                      color:Colors.grey[500]
                  )
              )
          ),
          SizedBox(height:w*0.10),
          SizedBox(height:w*0.02),
        ],
      ),
    );
  }
}