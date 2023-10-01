import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/screens/chatDetailPage.dart';
import 'package:medicare/styles/colors.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // StreamController<QuerySnapshot<Map<String, dynamic>>> streamController =
  //     StreamController<QuerySnapshot<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> listoPisto = [];
  List<String> listodoctorId = [];
  List<String> consultingId = [];
  List<String> doctorName = [];

/*

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('doctors').get().then((event) {
      for (var element in event.docs) {
        streamController.addStream(FirebaseFirestore.instance
            .collection('doctors')
            .doc(element.id)
            .collection('doctorConsulting')
            .where('ClientId', isEqualTo: currentUser.uid)
            .where('acceptedChat', isEqualTo: true)
            .snapshots()
            .map((event) {
          return event;
        }));
      }
    });
  }
*/

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('doctors')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> doctorsSnapshot) {
      List<Map<String, dynamic>> listopesto = [];
      for (var doctorDoc in doctorsSnapshot.docs) {
        listodoctorId.add(doctorDoc.id);

        FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorDoc.id)
            .collection('doctorConsulting')
            .where('ClientId', isEqualTo: currentUser.uid)
            .where('acceptedChat', isEqualTo: true)
            .get()
            .then((QuerySnapshot<Map<String, dynamic>> consultingSnapshot) {
          for (var consultingDoc in consultingSnapshot.docs) {
            Map<String, dynamic> documentData = consultingDoc.data();
            consultingId.add(consultingDoc.id);
            listopesto.add(documentData);
            if (mounted) {
              setState(() {});
            }
          }
        });
      }
      listoPisto = listopesto;
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
                              Text("إستشاراتك",
                                  style: TextStyle(
                                      color: Color(MyColors.header01),
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
              child: ListView.builder(
                itemCount: listoPisto.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> data = listoPisto[index];
                  print('data : $data');

                  DateTime now = data['date'].toDate();
                  DateFormat formatter = DateFormat.yMd().add_jm();
                  String messageTime = formatter.format(now);
                  String? doctorName = data['doctorName'];
                  List DoctorId = listodoctorId;
                  List Consultingid = consultingId;

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: const [
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
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'رسالة من دكتور : $doctorName',
                                  // 'نص الرسالة : $content',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'تم الإرسال فى : $messageTime',
                                  style:
                                      TextStyle(color: Color(MyColors.grey02)),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(MyColors.kprimaryButtonsColor),
                            ),
                            child: Text('فتح المحادثة'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailPage(
                                      ConsultingId: Consultingid[index],
                                      DoctorId: DoctorId[index],
                                      chatName: doctorName!),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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
