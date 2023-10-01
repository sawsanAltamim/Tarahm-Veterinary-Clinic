import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/components/defaultTextField.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/screens/home.dart';
import 'package:medicare/styles/colors.dart';

class RequestToCreateDoctor extends StatefulWidget {
  const RequestToCreateDoctor({Key? key}) : super(key: key);

  @override
  State<RequestToCreateDoctor> createState() => _RequestToCreateDoctorState();
}

class _RequestToCreateDoctorState extends State<RequestToCreateDoctor> {
  final name = TextEditingController();
  final numberPhone = TextEditingController();
  final address = TextEditingController();
  final experience = TextEditingController();
  final description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String userId = "";

  Future createClinic() async {
    CollectionReference userref =
        FirebaseFirestore.instance.collection('doctors');
    userref.add({
      "userId": userId,
      'name': name.text,
      'number_phone': numberPhone.text,
      'address': address.text,
      'experience': experience.text,
      'description': description.text,
      'consultingCount': 0,
      'ratings': [0],
      'doctors_acceptance': false,
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  var _image;
  var imagepicker;

  @override
  void initState() {
    imagepicker = ImagePicker();
    super.initState();
    getCurrentUserUid().then((uid) {
      setState(() {
        userId = uid;
      });
    });
  }

  @override
  void dispose() { // يعطلها اذا لم يتم استخدامها
    name.dispose();
    numberPhone.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;
    ScreenUtil.init(context); // عشان التطبيق يكن رسبونسف , ياخذ عرض الجوال
    return Scaffold(
      body: SafeArea( // حدود فوق وتحت عشان مايتداخل مع الساعه
          child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: SingleChildScrollView(  // اذا كان فيه عناصر كثير ومحتوى كثير احتاج انزل لتحت
        // تنفذ المحتوى بااكمله ومشاهدته في شاشه وحده
          child: Form( // نربط التكست فيلد كلها مع البوتون حيث عند الضغط بيتحقق من الكل بشكل تلقائي
          // بحيث ماينتقل لصفحه جديده اله اذا كان المسخدم اضاف كل البيانات في التكست فيلد
            key: _formKey, // عمليه التحقق تم ربطها
            child: Column(
              children: [
                SizedBox(
                  height: 50.sp,
                ),
                Text(
                  "طلب التقديم كطبيب",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Color(MyColors.text01),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15.sp,
                ),
                defaultFormField(
                  borderradius: 50, 
                  hintText: "الإسم ثلاثي",
                  controller: name,
                  fontsize: 18,
                  type: TextInputType.name, // نوع التكست
                  contentPaddinghorizontal: 20, // مكان النص افقيا
                  contentPaddingvertical: 10, // عرض التكست
                  onSaved: (newValue) => newValue!, //عشان عن احصل على البيانات الموجوده داخل التكست 
                ),
                SizedBox(
                  height: 15.sp,
                ),
                defaultFormField(
                  borderradius: 8,
                  hintText: "العنوان",
                  controller: address,
                  fontsize: 18,
                  type: TextInputType.name,
                  contentPaddinghorizontal: 20,
                  contentPaddingvertical: 10,
                  onSaved: (newValue) => newValue!,
                  validator: (value) { // يتحقق اذا القيمه فارغه
                    if (value!.isEmpty) { 
                      return 'هذا الحقل مطلوب'; // بيرجع ذي
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 15.sp,
                ),
                defaultFormField(
                  borderradius: 8,
                  hintText: "عدد سنوات الخبرة",
                  controller: experience,
                  fontsize: 18,
                  type: TextInputType.number,
                  contentPaddinghorizontal: 20,
                  contentPaddingvertical: 10,
                  onSaved: (newValue) => newValue!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    if (int.tryParse(value) == null) { //
                      return 'لبد ان تكون القيمة رقم';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 15.sp,
                ),
                defaultFormField(
                  borderradius: 8,
                  hintText: "وصف مختصر",
                  controller: description,
                  fontsize: 18,
                  type: TextInputType.text,
                  contentPaddinghorizontal: 20,
                  contentPaddingvertical: 10,
                  onSaved: (newValue) => newValue!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 15.sp,
                ),
                defaultFormField(
                  borderradius: 8,
                  hintText: "رقم الهاتف",
                  controller: numberPhone,
                  fontsize: 18,
                  type: TextInputType.name,
                  contentPaddinghorizontal: 20,
                  contentPaddingvertical: 10,
                  onSaved: (newValue) => newValue!,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 50.sp,
                ),
                GestureDetector( // اذا ضغطت على العناصر اللي داخلها بينفذ امر معين اي يعني حدث
                  onTap: () {
                    if (_formKey.currentState!.validate()) { // بعد مايتحقق ان كل التكست فيلد تمت تعبيته
                      createClinic();
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: const [
                          Color.fromRGBO(23, 128, 4, 1),
                          Color.fromRGBO(51, 223, 0, .6),
                        ])),
                    child: Center(
                      child: Text(
                        "تقديم الطلب",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
