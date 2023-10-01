import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicare/screens/NavBar.dart';
import 'package:medicare/styles/colors.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('customUsers').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: scaffoldKey,
          drawer: const NavBar(),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      scaffoldKey.currentState!.openDrawer();
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/person.jpg'),
                                    ),
                                  ),
                                  Spacer(),
                                  Text("كل المستخدمين",
                                      style: TextStyle(
                                          color: Color(
                                              MyColors.kprimaryButtonsColor),
                                          fontWeight: FontWeight.w800)),
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
                  child: StreamBuilder<QuerySnapshot>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            String? customerName = data['name'];

                            String? customerNumber = data['number'];
                            String Role = data['role'];

                            String customerRole = "";

                            if (Role == "user") {
                              customerRole = "عميل عادى";
                            } else if (Role == "doctor") {
                              customerRole = "دكتور";
                            } else if (Role == "clinic") {
                              customerRole = "عيادة";
                            } else if (Role == "admin") {
                              customerRole = "أدمن";
                            }

                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        // CircleAvatar(
                                        //   backgroundImage:
                                        //       AssetImage(_schedule['img']),
                                        // ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "إسم المستخدم : $customerName",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Color(MyColors.header01),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 50),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'رقم الهاتف : $customerNumber',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            'نوع المستخدم :  $customerRole',
                                            style: TextStyle(
                                                color: Color(MyColors.grey02)),
                                          ),
                                          // Text(
                                          //   'البريد : ${_schedule['email']}',
                                          //   textAlign: TextAlign.right,
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //     color: Colors.black54,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
