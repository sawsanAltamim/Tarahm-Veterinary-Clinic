import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicare/screens/NavBar.dart';
import 'package:medicare/styles/colors.dart';

class Adminrequests extends StatefulWidget {
  const Adminrequests({Key? key}) : super(key: key);

  @override
  State<Adminrequests> createState() => _AdminrequestsState();
}

class _AdminrequestsState extends State<Adminrequests> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('doctors')
      .where('doctors_acceptance', isEqualTo: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;

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
                                  width: ksize.width * 0.26,
                                ),
                                Text("طلبات الانضمام للأطباء",
                                    style: TextStyle(
                                        color: Color(
                                            MyColors.kprimaryButtonsColor),
                                        fontWeight: FontWeight.w800)),
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
                            String name = data['name'];
                            String numberPhone = data['number_phone'];
                            String address = data['address'];
                            String doctorId = data['userId'];
                            // String image = data['image'];
                            String documentId = snapshot.data!.docs[index].id;

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
                                              name,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: ksize.width * 0.3,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(MyColors.yellow01),
                                            ),
                                            child: Text('قبول '),
                                            onPressed: () {
                                              Future doctorAccepted() async {
                                                CollectionReference clinicsref =
                                                    FirebaseFirestore.instance
                                                        .collection('doctors');

                                                clinicsref
                                                    .doc(documentId)
                                                    .update({
                                                  'doctors_acceptance': true,
                                                });
                                              }

                                              doctorAccepted();
                                              Future<void>
                                                  updateDocumentRole() async {
                                                QuerySnapshot snapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'customUsers')
                                                        .where('uid',
                                                            isEqualTo: doctorId)
                                                        .get();

                                                await FirebaseFirestore.instance
                                                    .collection('customUsers')
                                                    .doc(snapshot.docs[0].id)
                                                    .update({'role': 'doctor'});
                                              }

                                              updateDocumentRole();
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: ksize.width * 0.3,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[400],
                                            ),
                                            child: Text('رفض '),
                                            onPressed: () => {},
                                          ),
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
