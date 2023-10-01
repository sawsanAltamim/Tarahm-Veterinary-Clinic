import 'package:flutter/material.dart';
import 'package:medicare/styles/colors.dart';
//   try {

//   } catch (e) {
//     // Handle the exception here
//     print('An error occurred: $e');
//   }
// }
class defaultFormField extends StatelessWidget { // عشان اذا استدعيته بعدين بيكون فيه كل الخصئص اللي حددتها فيه
  const defaultFormField(
      {Key? key,
      required this.hintText,
      required this.type,
      this.onSaved,
      this.controller,
      this.borderradius = 12,
      this.contentPaddinghorizontal = 20,
      this.contentPaddingvertical = 10,
      this.fontsize = 16,
      this.bordercolor = Colors.grey,
      this.textColor = Colors.grey,
      this.isEye = false,
      this.validator})
      : super(key: key);

  final String hintText;
  final double borderradius;
  final double contentPaddinghorizontal;
  final double contentPaddingvertical;
  final TextInputType type;
  final double fontsize;
  final Color bordercolor;
  final Color textColor;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool isEye;
  final String? Function(String?)? validator; // Added validator property

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      onSaved: onSaved,
      textAlign: TextAlign.right,
      cursorColor: Color(MyColors.header01),
      textDirection: TextDirection.rtl,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: isEye ? const Icon(Icons.remove_red_eye) : null,
        hintStyle: TextStyle(fontSize: fontsize, color: textColor),
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 243, 33, 33), // set the color here
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: contentPaddinghorizontal,
          vertical: contentPaddingvertical,
        ),
      ),
    );
  }
}

TextFormField defaultFormFieldWithIcon({
  required String hintText,
  required double borderradius,
  contentPaddinghorizontal = 20,
  contentPaddingvertical = 0,
  required TextInputType type,
  double fontsize = 16,
  required Color bordercolor,
  void Function(String?)? onSaved,
}) {
  return TextFormField(
    keyboardType: type,
    onSaved: onSaved,
    textAlign: TextAlign.right,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: fontsize),
      prefixIcon: const Icon(Icons.search),
      prefixIconColor: Colors.grey,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: bordercolor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(borderradius),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: contentPaddinghorizontal,
        vertical: contentPaddingvertical,
      ),
    ),
  );
}
