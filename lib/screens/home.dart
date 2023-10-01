import 'package:flutter/material.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/screens/NavBar.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/tabs/HomeTab.dart';
import 'package:medicare/tabs/Messages.dart';
import 'package:medicare/tabs/Profile.dart';
import 'package:medicare/tabs/clinics/clinics_Appointment.dart';
import 'package:medicare/tabs/doctors/doctors_Appointment.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String rolename = "";

  List<Map<String, dynamic>> navigationBarItems = [];

  void goToClinics() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  void goToDoctors() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  void initState() {
    super.initState();

    getRoleCurrentUser().then((role) {
      setState(() {
        rolename = role;
        if (rolename == "user") {
          navigationBarItems = [
            {'icon': Icons.local_hospital, 'index': 0},
            {'icon': Icons.calendar_today, 'index': 1},
            {'icon': Icons.question_answer_outlined, 'index': 2},
            {'icon': Icons.message_outlined, 'index': 3},
            {'icon': Icons.person_outlined, 'index': 4},
          ];
        } else {
          navigationBarItems = [
            {'icon': Icons.local_hospital, 'index': 0},
            {'icon': Icons.calendar_today, 'index': 1},
            {'icon': Icons.question_answer_outlined, 'index': 2},
            {'icon': Icons.person_outlined, 'index': 4},
          ];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [];
    if (rolename == "user") {
      screens = [
        HomeTab( // صفحه الهوم
          onPressedScheduleCard: goToClinics,
          onPressedScheduleCard2: goToDoctors,
        ),
        ScheduleTabClinics(), // واجهه الكلنك
        ScheduleTabDoctors(), // الدكاتره
        Messages(), // الرسائل
        ProfileDetail(), // حقت تعديل البيانات
      ];
    } else {
      screens = [
        HomeTab(
          onPressedScheduleCard: goToClinics,
          onPressedScheduleCard2: goToDoctors,
        ),
        ScheduleTabClinics(),
        ScheduleTabDoctors(),
        ProfileDetail(),
      ];
    }

    if (navigationBarItems.length < 2) { // اذا طلع الايكون اقل من 2لا
      return CircularProgressIndicator(); // Display a loading indicator until the items are available
    }

    return Directionality( // اتجاهه الرساله
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar( // الحدود اللي فوق
          backgroundColor: Color(MyColors.primary),
          elevation: 0, // الايشدو الضل
          toolbarHeight: 0, // طوله
        ),
        body: SafeArea(
          child: screens[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0, // المسافه الي تحت الايكون
          selectedItemColor: Color(MyColors.primary),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            for (var navigationBarItem in navigationBarItems)
              BottomNavigationBarItem(
                icon: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border(
                      top: _selectedIndex == navigationBarItem['index']
                          ? BorderSide(color: Color(MyColors.bg01), width: 5) // الخط اللي فوق الايكون
                          : BorderSide.none,
                    ),
                  ),
                  child: Icon(
                    navigationBarItem['icon'],
                    color: _selectedIndex == 0
                        ? Color(MyColors.bg01)
                        : Color(MyColors.bg02),
                  ),
                ),
                label: '',
              ),
          ],
          currentIndex: _selectedIndex,
          onTap: (value) => setState(() {
            _selectedIndex = value;
          }),
        ),
      ),
    );
  }
}
