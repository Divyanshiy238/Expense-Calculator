import 'package:expense_calculator/homepage.dart';
import 'package:expense_calculator/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'auth_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var emailController = TextEditingController();
  var passwordController=TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {

    List images=[
      "g.png",
      "t.png",
      "f.png",
    ];
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor : Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children:[
              Container(
                  width: w,
                  height: h*0.30,
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
                        SizedBox(height:h*0.13,),
                        CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent,
                          radius: 50,
                          backgroundImage: AssetImage(
                              "img/login2.png"
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
                            controller:passwordController,
                            decoration: InputDecoration(
                                hintText:"Password",
                                prefixIcon:Icon(Icons.email_outlined,color:Colors.deepPurpleAccent),
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
              SizedBox(height:60,),
              GestureDetector(
                onTap:() async {
                  setState((){
                    _loading = true;
                  });
                  await AuthenticationHelper()
                      .signUp(email: emailController.text.trim(), password: passwordController.text)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                    setState((){
                      _loading = false;
                    });
                  });
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
                    child: _loading ? Container(
                      margin: EdgeInsets.all(5),
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    ) : Text(
                      "Sign up",
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
                      recognizer: TapGestureRecognizer()..onTap=()=>Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                      text:"Have an account?",
                      style:TextStyle(
                          fontSize:20,
                          color:Colors.grey[500]
                      )
                  )
              ),
              SizedBox(height:w*0.10),
              RichText(text:TextSpan(
                text:"Sign up using one of the following methods",
                style: TextStyle(
                    color:Colors.grey[500],
                    fontSize:17
                ),
              )
              ),
              SizedBox(height:w*0.02),
              Wrap(
                children: List<Widget>.generate(
                    3,
                        (index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius:30,
                          backgroundColor: Colors.grey[500],
                          child: CircleAvatar(
                            radius:25,
                            backgroundImage: AssetImage(
                                "img/"+images[index]
                            ),
                          ),
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

