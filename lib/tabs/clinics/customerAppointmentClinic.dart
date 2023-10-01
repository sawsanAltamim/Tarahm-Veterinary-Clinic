import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/controller/sendEmail.dart';
import 'package:medicare/screens/NavBar.dart';
import 'package:intl/intl.dart';
import 'package:medicare/styles/colors.dart';
import 'dart:ui' as ui;

class customerAppointmentClinic extends StatefulWidget {
  const customerAppointmentClinic({Key? key}) : super(key: key);

  @override
  State<customerAppointmentClinic> createState() =>
      _customerAppointmentClinicState();
}

class _customerAppointmentClinicState extends State<customerAppointmentClinic> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = DateTime.now();

  String userId = "";
  static String? documentId;
  String Useremail = '';

  static Future<void> initialize() async { // اول مايفتح الصفحه يجيب الفاكشن
    documentId = await getclinicAppointmentsDocument();
  }

  Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('clinics')
      .doc(documentId)
      .collection('clinicAppointments')
      .snapshots();

  @override
  void initState() {
    super.initState();
    getCurrentUserUid().then((uid) {
      setState(() {
        userId = uid;
      });
    });
    getclinicAppointmentsDocument().then((id) {
      setState(() {
        documentId = id;
        stream = FirebaseFirestore.instance
            .collection('clinics')
            .doc(documentId)
            .collection('clinicAppointments')
            .snapshots();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
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
                                SizedBox(
                                  width: 140,
                                ),
                                Text(
                                  " مواعد العملاء مع عيادتك",
                                  style: TextStyle(
                                      color: Color(MyColors.header01),
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
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
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            String AppointmentId =
                                snapshot.data!.docs[index].id;

                            DateTime now = data['date'].toDate();
                            DateFormat formatter = DateFormat.yMd().add_jm();
                            String formatted = formatter.format(now);

                            String? customerName = data['customerName'];

                            String presonBookingId = data['presonbookingid'];
                            String? numberPhone = data['numberPhone'];
                            bool acceptedDate = data['acceptedDate'];
                            String? clinicName = data['clinicName'];
                            // String image = data['image'];
                            String ueerMail = data['ueerMail'];

                            Future<String?> getCurrentEmail(
                                String presonBookingId) async {
                              FirebaseAuth auth = FirebaseAuth.instance;
                              User? user = auth.currentUser;
                              if (user != null) {
                                String? email = user.email;
                                return email;
                              }
                              return null;
                            }

                            Future<void> getEmail(String clientId) async {
                              String? email = await getCurrentEmail(clientId);
                              if (email != null) {
                                setState(() {
                                  Useremail = email;
                                });
                              }
                            }

                            getEmail(presonBookingId);
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
                                        //   child: ClipOval(
                                        //       child: Image.network(
                                        //     image,
                                        //     fit: BoxFit.cover,
                                        //   )),
                                        // ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              "موعد الحجز المطلوب : $formatted",
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
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'الطلب مقدم من: $customerName',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'رقم الهاتف: $numberPhone',
                                            style: TextStyle(
                                                color: Color(MyColors.grey02)),
                                          ),
                                          Text(
                                            'البريد: $ueerMail',
                                            style: TextStyle(
                                                color: Color(MyColors.grey02)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    acceptedDate == false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 140,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Color(
                                                        MyColors.header01),
                                                  ),
                                                  child: Text('قبول '),
                                                  onPressed: () {
                                                    Future
                                                        clinicAppointmentsAccepted() async {
                                                      CollectionReference
                                                          mainCollectionRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection('clinics');
                                                      DocumentReference
                                                          documentRef =
                                                          mainCollectionRef
                                                              .doc(documentId)
                                                              .collection(
                                                                  'clinicAppointments')
                                                              .doc(
                                                                  AppointmentId);

                                                      documentRef.update({
                                                        'acceptedDate': true,
                                                      });
                                                    }

                                                    clinicAppointmentsAccepted();
                                                    sendEmail(
                                                      ueerMail,
                                                      "مرحباً بك يا :: $customerName لديك رساله من تطبيق تراحم",
                                                      " تم  قبول حجز موعد فى عيادة $clinicName بتاريخ ${DateTime.now()}",
                                                    );
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 140,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red[500],
                                                  ),
                                                  child: Text('رفض '),
                                                  onPressed: () {
                                                    Future
                                                        clinicAppointmentsAccepted() async {
                                                      CollectionReference
                                                          mainCollectionRef =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'clinics');
                                                      DocumentReference
                                                          documentRef =
                                                          mainCollectionRef
                                                              .doc(documentId)
                                                              .collection(
                                                                  'clinicAppointments')
                                                              .doc(
                                                                  AppointmentId);

                                                      await documentRef
                                                          .delete();
                                                    }

                                                    clinicAppointmentsAccepted();
                                                    sendEmail(
                                                      ueerMail,
                                                      "مرحباً بك يا :: $customerName لديك رساله من تطبيق تراحم",
                                                      " تم رفض حجز موعد فى عيادة $clinicName بتاريخ ${DateTime.now()}",
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox( // alse
                                            width: 140,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(MyColors.header01),
                                              ),
                                              child: Text('تم الحجز'),
                                              onPressed: () {},
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        Center(child: Text('لا يوجد عيادات'));
                      }
                      return Center(
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg03),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                '11:00 ~ 12:10',
                style: TextStyle(
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.access_alarm,
                color: Color(MyColors.primary),
                size: 17,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'الاحد, مارس 29',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.calendar_today,
                color: Color(MyColors.primary),
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
