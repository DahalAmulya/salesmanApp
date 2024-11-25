extension DurationFormat on Duration{
  RegExpMatch? secToTime (){
    String time =  'DateTime.now()';
    return RegExp(r'(^0*[1-9] \d*:)?\d{2}: \d{2})\. \d+$').firstMatch(time);
  }
}



//RegExpE' ( (^0*[1-9] \d*:)?\d{2}: \d{2})\. \d+$')