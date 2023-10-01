import 'package:flutter/material.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';

class HomeTab extends StatelessWidget {
  final void Function() onPressedScheduleCard;
  final void Function() onPressedScheduleCard2;

  const HomeTab({
    Key? key,
    required this.onPressedScheduleCard,
    required this.onPressedScheduleCard2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            UserIntro(),
            SizedBox(
              height: 20,
            ),
            // SearchInput(),
            SizedBox(
              height: 20,
            ),
            // CategoryIcons(),
            SizedBox(
              height: 20,
            ),
            Text(
              'تصفح خدمتك',
              style: kTitleStyle,
            ),
            SizedBox(
              height: 20,
            ),
            AppointmentCard(
              onTap: onPressedScheduleCard,
            ),
            SizedBox(
              height: 20,
            ),
            AppointmentCard2(
              onTap: onPressedScheduleCard2,
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final void Function() onTap;

  const AppointmentCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(MyColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    ScheduleCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg02),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg03),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentCard2 extends StatelessWidget {
  final void Function() onTap;

  const AppointmentCard2({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(MyColors.kprimaryButtonsColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    ScheduleCard2(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.ksecondaryButtonCcolor),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.ksecondaryColor),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg01),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "إحجز موعد مع عيادة",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ScheduleCard2 extends StatelessWidget {
  const ScheduleCard2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.kliteblueButtonCcolor),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "طلب إستشارة فورية",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// class SearchInput extends StatelessWidget {
//   const SearchInput({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Color(MyColors.bg),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 3),
//             child: Icon(
//               Icons.search,
//               color: Color(MyColors.purple02),
//             ),
//           ),
//           const SizedBox(
//             width: 15,
//           ),
//           Expanded(
//             child: TextField(
//               textAlign: TextAlign.right,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'إبحث عن دكتورك المناسب',
//                 hintStyle: TextStyle(
//                     fontSize: 13,
//                     color: Color(MyColors.purple01),
//                     fontWeight: FontWeight.w700),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class UserIntro extends StatefulWidget {
  const UserIntro({
    Key? key,
  }) : super(key: key);

  @override
  State<UserIntro> createState() => _UserIntroState();
}

class _UserIntroState extends State<UserIntro> {
  String _name = '';
  @override
  void initState() {
    super.initState();
    getCurrentUseData().then((name) {
      setState(() {
        _name = name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/trahumLogo.jpg',
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'مرحبا بك',
              style: TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Text(
              _name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
