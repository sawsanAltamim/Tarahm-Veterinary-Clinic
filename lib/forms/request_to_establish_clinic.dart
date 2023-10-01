import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/components/defaultTextField.dart';
import 'package:medicare/controller/firebase_data.dart';
import 'package:medicare/screens/home.dart';
import 'package:medicare/styles/colors.dart';

class RequestToEstablishClinic extends StatefulWidget {
  const RequestToEstablishClinic({Key? key}) : super(key: key);

  @override
  State<RequestToEstablishClinic> createState() =>
      _RequestToEstablishClinicState();
}

class _RequestToEstablishClinicState extends State<RequestToEstablishClinic> {
  final title = TextEditingController();
  final numberPhone = TextEditingController();
  final timesofwork = TextEditingController();
  final address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String userId = "";

  Future createClinic() async {
    CollectionReference userref =
        FirebaseFirestore.instance.collection('clinics');
    // CollectionReference customUsersref =
    //     FirebaseFirestore.instance.collection('customUsers');
    userref.add({
      "userId": userId,
      'title': title.text,
      'number_phone': numberPhone.text,
      'address': address.text,
      'clinic_acceptance': false,
    });
    // customUsersref.add({
    //   "uid": currentUser.uid,
    //   'role': "clinic",
    // });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  var _image;
  var imagepicker;

  // uploadImage() async {
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  // }

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
  void dispose() {
    title.dispose();
    numberPhone.dispose();
    timesofwork.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size ksize = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50.sp,
                ),
                Text(
                  "طلب إنشاء عيادة",
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
                  hintText: "إسم العيادة",
                  controller: title,
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
                  hintText: "مواعيد العمل",
                  controller: timesofwork,
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
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
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
