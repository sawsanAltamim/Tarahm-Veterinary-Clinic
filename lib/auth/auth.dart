import 'package:flutter/material.dart';
import 'package:medicare/screens/home.dart';
import 'package:medicare/auth/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends StatelessWidget {
  const Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // عباره عن الشاشه , كل اللي بالشاشه جوا الشاشه
    // الشاشه كلها
        body: StreamBuilder<User?>( // عرض البيانات الموجوده في الاوث ك ريل تايم
      stream: FirebaseAuth.instance.authStateChanges(), // يجيب البيانات من الفاير بيس ويحولها الى ريل تايم بمعنى اذا فيه حجر وتم قبوله بتتحدث الصفحه على طول
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else {
          return loginScreen();
        }
      }),
    ));
  }
}
