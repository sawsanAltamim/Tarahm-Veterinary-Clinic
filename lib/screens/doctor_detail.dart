import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';

class DoctorDetail extends StatefulWidget {
  const DoctorDetail({Key? key, required this.doctorId}) : super(key: key);
  final String doctorId;

  @override
  State<DoctorDetail> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text('تفاصيل الطبيب'),
              backgroundColor: Color(MyColors.primary),
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                  image: AssetImage('assets/team-doctors.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: DetailBody(doctorId: widget.doctorId),
            )
          ],
        ),
      ),
    );
  }
}

class DetailBody extends StatefulWidget {
  const DetailBody({
    Key? key,
    required this.doctorId,
  }) : super(key: key);
  final String doctorId;
  @override
  State<DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  String _doctorName = "";
  String _doctorNumberPhone = "";
  String _doctorAddress = "";
  String _doctorDescription = "";
  List<dynamic> _doctorRatings = [0];
  String _doctorExperience = "0";
  int _doctorConsultingCount = 0;

  Future<void> fetchDocument() async {
    final doc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.doctorId)
        .get();

    final data = doc.data() as Map<String, dynamic>;

    setState(() {
      _doctorName = data['name'] ?? '';
      _doctorNumberPhone = data['number_phone'] ?? '';
      _doctorAddress = data['address'] ?? '';
      _doctorDescription = data['description'] ?? '';
      _doctorExperience = data['experience'] ?? 0;
      _doctorRatings = data['ratings'] ?? 0;
      _doctorConsultingCount = data['consultingCount'] ?? 0;
    });
  }

// Call the function wherever necessary
  @override
  void initState() {
    super.initState();
    fetchDocument();
    print('consultingCount ID: $_doctorConsultingCount');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailDoctorCard(
              doctorName: _doctorName, doctorNumberPhone: _doctorNumberPhone),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              NumberCard(
                label: 'خبرة',
                value: ' $_doctorExperience  سنة  ',
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'ماذا عن الطبيب',
            style: kTitleStyle,
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            _doctorDescription,
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'الموقع',
            style: kTitleStyle,
            textAlign: TextAlign.right,
          ),
          Text(
            _doctorAddress,
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String title;
  final String desc;
  const AboutDoctor({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg03),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  const DetailDoctorCard({
    Key? key,
    required this.doctorName,
    required this.doctorNumberPhone,
  }) : super(key: key);
  final String doctorName;
  final String doctorNumberPhone;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$doctorName دكتور ",
                        style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$doctorNumberPhone هاتف ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(MyColors.grey02),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image(
                image: AssetImage('assets/doctors/Doctor-png.png'),
                width: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
