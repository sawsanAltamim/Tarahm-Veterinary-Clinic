import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/screens/home.dart';
import 'package:medicare/styles/colors.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  static String? useruid;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberphoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> initialize() async {
    getCurrentUseData();
    getCurrentUserNumberPhone();
    getCurrentEmail();
  }

  String _name = "";
  String _number = "";

  String? nameContent = "";
  String? numberContent = "";
  String? emailContent = "";

  // Future<void> updateEmail(String emailContent) async {
  //   User? user = _auth.currentUser;
  //   await user?.updateEmail(emailContent);
  // }

  @override
  void initState() {
    super.initState();

    getCurrentUseData().then((name) {
      setState(() {
        _name = name;
      });
    });
    getCurrentUserNumberPhone().then((number) {
      setState(() {
        _number = number;
      });
    });
    setState(() {
      useruid = currentUser.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/person.jpg'),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "صفحتك الشخصية",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(MyColors.primary)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
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
                                  // Container(
                                  //   height: 64,
                                  //   padding: EdgeInsets.only(right: 12.0),
                                  //   decoration: BoxDecoration(
                                  //     border: Border(
                                  //       bottom: BorderSide(color: Colors.grey),
                                  //     ),
                                  //   ),
                                  //   child: TextField(
                                  //     onChanged: (value) {
                                  //       emailContent = value;
                                  //     },
                                  //     controller: _emailController,
                                  //     textAlign: TextAlign.right,
                                  //     decoration: InputDecoration(
                                  //       border: InputBorder.none,
                                  //       hintText:
                                  //           'بريدك الاليكترونى : ${currentUser.email}',
                                  //       hintStyle: TextStyle(
                                  //         fontSize: 16,
                                  //         color: Colors.grey[400],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    height: 64,
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        nameContent = value;
                                      },
                                      controller: _nameController,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'إسمك كامل : $_name',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 64,
                                    padding: EdgeInsets.only(right: 12.0),
                                    child: TextField(
                                      onChanged: (value) {
                                        numberContent = value;
                                      },
                                      controller: _numberphoneController,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'رقم الهاتف : $_number',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Future<void> updateNameProfile() async {
                                  QuerySnapshot snapshot =
                                      await FirebaseFirestore.instance
                                          .collection('customUsers')
                                          .where('uid', isEqualTo: useruid)
                                          .get();

                                  FirebaseFirestore.instance
                                      .collection('customUsers')
                                      .doc(snapshot.docs[0].id)
                                      .update({
                                    'name': nameContent,
                                  });
                                }

                                Future<void> updateNumberProfile() async {
                                  QuerySnapshot snapshot =
                                      await FirebaseFirestore.instance
                                          .collection('customUsers')
                                          .where('uid', isEqualTo: useruid)
                                          .get();

                                  FirebaseFirestore.instance
                                      .collection('customUsers')
                                      .doc(snapshot.docs[0].id)
                                      .update({
                                    'number': numberContent,
                                  });
                                }

                                // if (emailContent != null &&
                                //     emailContent!.isNotEmpty) {
                                //   updateEmail(emailContent!);
                                // }
                                if (nameContent != null &&
                                    nameContent!.isNotEmpty) {
                                  updateNameProfile();
                                }
                                if (numberContent != null &&
                                    numberContent!.isNotEmpty) {
                                  updateNumberProfile();
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                              },
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
                                    "تعديل بياناتك",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
