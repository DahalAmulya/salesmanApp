String hoursToHMS(double totalHours) {
  // Convert total hours into hours, minutes, and seconds
  int hours = totalHours.floor(); // Get the whole number part (hours)
  double fractionalHours = totalHours - hours; // Get the fractional part

  int minutes =
      (fractionalHours * 60).floor(); // Convert fractional hours to minutes
  double fractionalMinutes =
      (fractionalHours * 60) - minutes; // Get the fractional part of minutes

  int seconds =
      (fractionalMinutes * 60).round(); // Convert fractional minutes to seconds

  // Format hours, minutes, and seconds with leading zero if less than 10
  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = seconds.toString().padLeft(2, '0');
  return '$formattedHours:$formattedMinutes:$formattedSeconds';
  // print(
  //     'Hours: $formattedHours, Minutes: $formattedMinutes, Seconds: $formattedSeconds');
}
