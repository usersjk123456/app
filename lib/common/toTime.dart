
class ToTime{
  static time(String times,[String type]){
    var time1 = DateTime.fromMillisecondsSinceEpoch(int.parse(times) * 1000);
    var time2;
    if(type == "YY"){
      time2 = time1.toString().split('.')[0].split(' ')[0];
    }else if(type == 'HH'){
      time2 = time1.toString().split('.')[0].split(' ')[1];
    }else{
      time2 = time1.toString().split('.')[0];
    }
    return time2;
  }
  // 
}