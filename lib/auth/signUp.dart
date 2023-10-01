import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicare/auth/loginScreen.dart';
import 'package:medicare/screens/home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool errorvisible = false;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberphoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> signUp() async { // عشان فيه عمليه اتصال في الداتا بيس
    bool passwordConfirmed() {
      if (_passwordController.text.trim() ==
          _confirmPasswordController.text.trim()) {
        return true;
      } else {
        return false;
      }
    }

    final FirebaseAuth _auth = FirebaseAuth.instance; // يعرفها
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('customUsers'); // يدخل على الفاير ستور ويجيب كولكشن الكوست يوزر

    // Check if the email already exists
    bool emailExists = false; // اذا الايميل ماتسجل فيه من قب
    QuerySnapshot snapshot = await userRef
        .where('email', isEqualTo: _emailController.text.trim()) // يجيب الايميل اللي تم تخزينه في الكنترلر
        .get(); // يحصل عليه
    if (snapshot.docs.isNotEmpty) {
      emailExists = true;
    }

    if (passwordConfirmed() && !emailExists) { // اذا القيمه رجعت بترو حقت الباسورد والايميل ليس موجود
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), // ياخذ الايميل بدون المسافات بمعنى يمسكه
          password: _passwordController.text.trim(), 
        );

        await userRef.add({ // بعدين يضيف في الكوستم يوزر 
          "uid": result.user?.uid, // اي دي المستخدم
          'name': _nameController.text, // والاسم
          'number': _numberphoneController.text, // الرقم
          'role': "user", // والرول تلقائي يكون يوزر
        });

        Navigator.push( // ينقلني لصفحه الهوم
          context,
          MaterialPageRoute(builder: (context) => Home()), 
        );
      } catch (e) { // عشان احتماليه حدوث خطأ
      // عشان اذا دخلت حاجه غلط
      // اذا دخلت حاجه غلط في التكست فيلد بيروح للكاتش
        String errorMessage = "";
        if (e is FirebaseAuthException) {
          errorMessage = e.message ?? "An error occurred during sign up."; // يرجع رساله الغلط
        } else {
          errorMessage = "An error occurred during sign up.";
        }

        showDialog( // المربع الصغير
          context: context,
          builder: (BuildContext context) {
            return Directionality( // اتجاه الكلام
              textDirection: TextDirection.rtl, // يمين
              child: AlertDialog( // نافذه بتظهر اذا نفذت حدث محدد لوظيفه محدده
                title: Text("خطأ"), // العنوان
                content: Text("هذا البريد تم إستخدامة من قبل"), // المحتوى
                actions: [ // اذا ضغطته يصير حدث
                  TextButton(
                    child: Text("إغلاق"),
                    onPressed: () {
                      Navigator.of(context).pop(); // يحذف النافذه الصغيره
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      String errorMessage = !passwordConfirmed() // اذا الباسورد غير متطابق 
          ? "Passwords do not match." // بيرجع هالرساله 
          : "Email already exists.";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text("خطأ"),
              content: Text(errorMessage), // الرساله اللي فوق
              actions: [
                TextButton(
                  child: Text("إغلاق"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() { // عشان يعطلها اذا مااستخدمتها عشان ماتاخذ حيز في الذاكره
    _emailController.dispose();
    _nameController.dispose();
    _numberphoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // هي الشاشه كلها , كل اللي بالشاشه موجود داخل السكفولد
        backgroundColor: Colors.white,
        body: SingleChildScrollView( // اذا كان فيه عناصر كثير ومحتوى كثير احتاج انزل لتحت
        // تنفذ المحتوى بااكمله ومشاهدته في شاشه وحده
          child: Container( // هو اللي يقسم السكفولد 
            child: Column( 
              children: <Widget>[
                Container( // اقدر فيه احدد حجم الكولوم
                  height: 400,
                  decoration: BoxDecoration( // استخدمها لتزيين الكونتر فيها خصائص
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)), // يعبي كل الكونتينر
                  child: Stack( //  اقدر احطها فوق عنصر واتحكم فيه مكانها يعني مرنه مو زي الكولوم
                    children: <Widget>[
                      Positioned( // مكانها
                        top: 60,
                        left: 20,
                        width: 100,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/cat.png'))),
                        ),
                      ),
                      Positioned( // بوزشن
                        bottom: 0,
                        left: 140,
                        width: 120,
                        height: 150,
                        child: Container( // تحجز مكان في الشاشه
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/dog.png"))),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/dog_rotate.png"))),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 120,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/cat.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center( // بالوسط
                            child: Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold), // شكل الخط بولد ولا مايل او مسطر
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column( // كولوم داخل كولوم
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5), // ابعاد داخل الكولوم
                        decoration: BoxDecoration( // تفر خصائص اضافيه لتزيين الصفحه
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 54,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border( // اضفت بوردر
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: _emailController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "ادخل البريد الاليكترونى",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              height: 54,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "الإسم ثلاثي",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              height: 54,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: _numberphoneController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "رقم الهاتف",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              height: 54,
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: TextField(
                                controller: _passwordController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "الرقم السري",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              height: 54,
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _confirmPasswordController,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "تأكيد الرقم السري",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: errorvisible, //  عشان مايطلع اله في حاله معينه
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "كلمة السر غير متطابقان",
                              style: TextStyle(
                                  color: Color.fromRGBO(209, 0, 0, 1)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: signUp, // فنكشن تم انشائه فوق
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: const [
                                Color.fromRGBO(23, 128, 4, 1),
                                Color.fromRGBO(51, 223, 0, .6),
                              ])),
                          child: Center( // يحطه بالنص
                            child: Text(
                              "إنشاء",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginScreen()),
                          );
                        },
                        child: Text(
                          " لديك حساب ؟",
                          style:
                              TextStyle(color: Color.fromRGBO(23, 128, 4, 1)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
