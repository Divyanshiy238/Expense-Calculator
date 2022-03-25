import 'package:expense_calculator/auth_controller.dart';
import 'package:expense_calculator/homepage.dart';
import 'package:expense_calculator/reset_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController=TextEditingController();
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
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
                          SizedBox(height:h*0.12,),
                          CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            radius: 60,
                            backgroundImage: AssetImage(
                                "img/img.png"
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
                        SizedBox(height:20,),
                        Text(
                          "Expense Calculator",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height:2,),
                        Text(
                          " Sign into your account",
                          style: TextStyle(
                              fontSize: 20,
                              color:Colors.grey[500]
                          ),
                        ),
                        SizedBox(height:35,),
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
                              controller: passwordController,
                              obscureText:true,
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
                        SizedBox(height: 10,),
                        Row(
                          children:[
                            Expanded(child: Container(),),
                            TextButton(
                              onPressed: ()=>{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:(context)=> ForgotPassword(),
                                  ),
                                )
                              }, child: Text(
                              "Forgot your Password?",
                              style: TextStyle(
                                  fontSize: 19,
                                  color:Colors.grey[500]
                              ),
                            ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                SizedBox(height:40,),
                GestureDetector(
                  onTap:() async {
                    setState((){
                      _loading = true;
                    });
                    await AuthenticationHelper().signIn(email: emailController.text.trim(), password: passwordController.text).then((value){
                      if (value == null) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => HomePage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            value,
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
                        "Sign in",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color:Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height:w*0.03),
                RichText(text:TextSpan(
                    text:"Don\'t have an account?",
                    style: TextStyle(
                        color:Colors.grey[500],
                        fontSize:20
                    ),
                    children:[
                      TextSpan(
                          text:" Sign up ",
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:20,
                            fontWeight: FontWeight.bold,
                          ),
                        recognizer: TapGestureRecognizer()..onTap=()=>Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignUpPage())),
                      ),
                    ]
                )
                ),
                SizedBox(
                  height: 15.0,
                )
              ]
          ),
        )
      ),
    );
  }
}
