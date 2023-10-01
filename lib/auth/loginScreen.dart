import 'package:flutter/material.dart';
import 'package:medicare/auth/forget_password.dart';
import 'package:medicare/auth/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicare/screens/home.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _loginErrorMessage;

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (error) {
      setState(() {
        _loginErrorMessage = "كلمة المرور او البريد غير صحيح ";
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
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
                              image:
                                  AssetImage("assets/images/dog_rotate.png"))),
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
                          "تسجيل الدخول",
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
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: TextField(
                            controller: _emailController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "ادخل البريد الاليكترونى",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _passwordController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "الرقم السري",
                              hintStyle: TextStyle(
                                  fontSize: 15, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: signIn,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: const [
                            Color.fromRGBO(23, 128, 4, 1),
                            Color.fromRGBO(51, 223, 0, .6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "تسجيل دخول",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_loginErrorMessage != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _loginErrorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
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
                          builder: (context) => ResetPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      "نسيت كلمة المرور ؟",
                      style: TextStyle(color: Color.fromRGBO(23, 128, 4, 1)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "ليس لديك حساب ؟",
                      style: TextStyle(color: Color.fromRGBO(128, 4, 4, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
