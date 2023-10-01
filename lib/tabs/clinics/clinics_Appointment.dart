import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleTabClinics extends StatefulWidget {
  const ScheduleTabClinics({Key? key}) : super(key: key);

  @override
  State<ScheduleTabClinics> createState() => _ScheduleTabClinicsState();
}

class _ScheduleTabClinicsState extends State<ScheduleTabClinics> {
  TextEditingController dateCtl = TextEditingController();
  static String? ClinicId;
  static String? Useruid;

  static Future<void> initialize() async {
    ClinicId = await getclinicAppointmentsDocument();
    getCurrentUseData();
    getCurrentUserNumberPhone();
  }

  Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('clinics')
      .where('clinic_acceptance', isEqualTo: true)
      .snapshots();

  DateTime? _selectedDate;

  String nameuser = "";
  String numberuser = "";
  String nuseruidame = "";

  @override
  void initState() {
    super.initState();

    getCurrentUseData().then((name) {
      setState(() {
        nameuser = name;
      });
    });
    getCurrentUserNumberPhone().then((number) {
      setState(() {
        numberuser = number;
      });
    });
    setState(() {
      Useruid = currentUser.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
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
                        child: GestureDetector(
                          onTap: () {},
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
                                Text("حجز عيادة",
                                    style: TextStyle(
                                        color: Color(MyColors.header01),
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
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
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepOrange,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        String ClinicId = snapshot.data!.docs[index].id;
                        String mytitle = data['title'];
                        String numberPhone = data['number_phone'];
                        String address = data['address'];
                        // String image = data['image'];

                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                          mytitle,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'رقم الهاتف : $numberPhone',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'عنوان العيادة:  $address',
                                        style: TextStyle(
                                            color: Color(MyColors.grey02)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 240,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color(MyColors.header01),
                                          ),
                                          child: Text('حجز موعد'),
                                          onPressed: () async {
                                            // Show the date picker
                                            DateTime? selectedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            Future
                                                clinicAppointmentsAccepted() async {
                                              try {
                                                final FirebaseAuth auth =
                                                    FirebaseAuth.instance;
                                                final User? currentUser =
                                                    auth.currentUser;
                                                final String? userEmail =
                                                    currentUser?.email;
                                                CollectionReference
                                                    mainCollectionRef =
                                                    FirebaseFirestore.instance
                                                        .collection('clinics')
                                                        .doc(ClinicId)
                                                        .collection(
                                                            'clinicAppointments');

                                                mainCollectionRef.add({
                                                  'acceptedDate': false,
                                                  'customerName': nameuser,
                                                  'date': _selectedDate,
                                                  'numberPhone': numberuser,
                                                  'presonbookingid': Useruid,
                                                  "clinicName": mytitle,
                                                  'ueerMail': userEmail,
                                                });
                                              } catch (e) {
                                                print(
                                                    'Error adding appointment chat: $e');
                                              }
                                            }

                                            // Update the selected date
                                            setState(() {
                                              _selectedDate =
                                                  selectedDate ?? _selectedDate;
                                              clinicAppointmentsAccepted();
                                            });
                                          }),
                                    ),
                                  ],
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
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepOrange,
                          ),
                        )),
                  );
                },
              ),
            ),
          ],
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
