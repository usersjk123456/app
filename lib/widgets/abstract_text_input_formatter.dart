import 'package:flutter/services.dart';

abstract class AbstractTextInputFormatter extends TextInputFormatter{

  RegExp generateRegExp();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    RegExp regExp = generateRegExp();
    if(regExp.hasMatch(newText)) {
      return newValue;
    }
    if(newText.isEmpty) {
      return TextEditingValue();
    }
    return oldValue;
  }
}

class EnglishTextInputFormatter extends AbstractTextInputFormatter {
  @override
  RegExp generateRegExp() {
    return RegExp(r"^[a-zA-Z]+$");
  }

}