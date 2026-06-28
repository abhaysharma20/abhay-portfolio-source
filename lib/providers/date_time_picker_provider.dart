import 'package:flutter/material.dart';

class DateTimePickerProvider with ChangeNotifier {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }
}
