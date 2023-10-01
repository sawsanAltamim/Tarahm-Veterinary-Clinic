import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/screens/doctor_detail.dart';
import 'package:medicare/screens/home.dart';
import 'package:medicare/styles/colors.dart';

class ScheduleTabDoctors extends StatefulWidget {
  const ScheduleTabDoctors({Key? key}) : super(key: key);

  @override
  State<ScheduleTabDoctors> createState() => _ScheduleTabDoctorsState();
}

class _ScheduleTabDoctorsState extends State<ScheduleTabDoctors> {
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('doctors')
      .where('doctors_acceptance', isEqualTo: true)
      .snapshots();

  String _name = '';
  final String _uemail = '';

  @override
  void initState() {
    super.initState();
    getCurrentUseData().then((name) {
      setState(() {
        _name = name;
      });
    });
    getCurrentEmail().then((uemail) {
      setState(() {
        _name = uemail;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showPopupMessage(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 150.sp,
              child: Column(
                children: [
                  Text(
                    "شكرا لقد تم تقديم طلب إستشارتك",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 23.sp),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(MyColors.kprimaryButtonsColor),
                      ),
                      child: Text(
                        "الصفحة الرئيسية",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      }),
                ],
              ),
            ),
          );
        },
      );
    }

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
                  height: 41,
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
                                "طلب إستشارة",
                                style: TextStyle(
                                  color: Color(MyColors.header01),
                                  fontWeight: FontWeight.w800,
                                ),
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
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        String doctorId = document.id;
                        String name = data['name'];
                        String experience = data['experience'];

                        List<dynamic>? ratingValues =
                            List<dynamic>.from(data['ratings']); // يجيب كل الراتنق حقت الدكتور 

                        int sunItemCount = ratingValues.length;

                        int sumRatings = 0;
                        int itemCount = 0;

                        for (var ratingValue in ratingValues) {
                          if (ratingValue is int) {
                            sumRatings += ratingValue;
                            itemCount++;
                          } else if (ratingValue is String) {
                            int? parsedRating = int.tryParse(ratingValue);
                            if (parsedRating != null) {
                              sumRatings += parsedRating;
                              itemCount++;
                            }
                          }
                        }

                        double averageRating =
                            itemCount != 0 ? sumRatings / itemCount : 0;
                        double maxRating = 5.0;
                        double rating = averageRating > maxRating
                            ? maxRating
                            : averageRating;

                        return Card(
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DoctorDetail(
                                              doctorId: doctorId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "دكتور $name",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Color(MyColors.header01),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        'عدد سنوات الخبرة: $experience',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Color(MyColors.grey02),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Color(MyColors.yellow02),
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '$sunItemCount - ${rating.toDouble()} تقييم',
                                            style: TextStyle(
                                              color: Color(MyColors.grey02),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color(MyColors.kprimaryButtonsColor),
                                  ),
                                  child: Text('طلب استشارة'),
                                  onPressed: () {
                                    DateTime now = DateTime.now();
                                    DateTime date =
                                        DateTime(now.year, now.month, now.day);

                                    Future<void>
                                        doctorAppointmentsChat() async {
                                      try {
                                        final FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        final User? currentUser =
                                            auth.currentUser;
                                        final String? userEmail =
                                            currentUser?.email;

                                        CollectionReference mainCollectionRef =
                                            FirebaseFirestore.instance
                                                .collection('doctors')
                                                .doc(doctorId)
                                                .collection('doctorConsulting');

                                        await mainCollectionRef.add({
                                          'acceptedChat': false,
                                          'customerName': _name,
                                          'date': date,
                                          'content': "من فضلك أريد إستشارة",
                                          'ClientId': currentUser?.uid,
                                          'doctorName': name,
                                          'ueerMail': userEmail,
                                        });

                                        print(
                                            'Appointment chat added successfully.');
                                      } catch (e) {
                                        print(
                                            'Error adding appointment chat: $e');
                                      }
                                    }

                                    doctorAppointmentsChat();
                                    _showPopupMessage(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('لا يوجد عيادات'));
                  }
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
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
