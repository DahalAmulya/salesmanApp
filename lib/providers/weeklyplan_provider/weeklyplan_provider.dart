import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class WeeklyPlanProvider with ChangeNotifier{
  DateTime? _SelectedDate ;

  DateTime get selectedDate => _SelectedDate!;

  void setSelectedDate(newDate) {
    _SelectedDate = newDate;
    notifyListeners();
  }
  String formattedDateTime (){
    return DateFormat('y/MM/dd,EEEE').format(DateTime.now());
  }
}

