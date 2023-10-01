import 'package:flutter/material.dart';
import 'package:medicare/auth/loginScreen.dart';
import 'package:medicare/auth/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  String success_Message = "";
  String error_Message = "";
  void _resetPassword() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        setState(() {
          success_Message = "تم إرسال البريد بنجاح";
        });
      } catch (e) {
        setState(() {
          error_Message = "بريد إليكترونى خاطئ";
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 50,
                        left: 20,
                        width: 100,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/cat.png'))),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 140,
                        width: 120,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/dog_rotate.png"))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 50,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/dog.png"))),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 120,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/cat.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "إعادة كلمة المرور",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "ادخل البريد الاليكترونى",
                                hintStyle: TextStyle(color: Colors.grey[400])),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (success_Message != null)
                        Text(
                          success_Message,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (error_Message != null)
                        Text(
                          error_Message,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: _resetPassword,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: const [
                                Color.fromRGBO(23, 128, 4, 1),
                                Color.fromRGBO(51, 223, 0, .6),
                              ])),
                          child: Center(
                            child: Text(
                              "إرسال",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginScreen()),
                          );
                        },
                        child: Text(
                          "سجل دخول ",
                          style:
                              TextStyle(color: Color.fromRGBO(23, 128, 4, 1)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          "ليس لديك حساب ؟",
                          style: TextStyle(color: Color.fromRGBO(128, 4, 4, 1)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
