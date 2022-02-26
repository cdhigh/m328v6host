/// 有关时间的一系列工具函数和扩展
/// 因为date_format包不是很好用，而intl又太大，所以自己简单封装一个扩展函数 format() 格式化时间
/// 格式：yyyy: 四位年份，mm：两位月份，dd：两位日期，HH：两位小时，MM：两位分钟，SS：两位秒
/// MMMM: 英文月份全称(January)，MMM：三位英文缩写月份(Jan...)，
/// EEEE: 英文星期(Monday...), EEE：三位英文星期缩写(Mon...)
/// Author: cdhigh <https://github.com/cdhigh>
/// 使用方法：time.format('yyyy-mm-dd HH:MM:SS')
import 'bisect.dart';
import '../i18n/common.i18n.dart';

extension When on DateTime {
  ///快捷函数，返回: yyyy-mm-dd HH:MM:SS格式
  String toStdString() => format('yyyy-mm-dd HH:MM:SS');
  ///快捷函数，返回DateString yyyy-mm-dd格式
  String toDateString() => format('yyyy-mm-dd');
  ///快捷函数，返回TimeString HH:MM:SS格式
  String toTimeString() => format('HH:MM:SS');

  ///简单的日期时间格式化函数，仅支持以下占位符：yyyy mm dd HH MM SS EEE MMM
  ///时间为null时返回空串
  String format(String fmt) {
    var sb = StringBuffer();
    var lastIndex = fmt.length - 1;
    var i = 0;
    var currChar = "";
    while (i <= lastIndex) {
      currChar = fmt[i];
      switch (currChar) {
        case 'y': //年份，必须四个yyyy
          if ((i + 3 <= lastIndex) && (fmt.substring(i, i + 4) == 'yyyy')) {
            sb.write(year.toString());
            i += 4;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        case 'm': //月份，必须两个mm
           if ((i + 1 <= lastIndex) && (fmt[i + 1] == 'm')) {
            sb.write(month.toString().padLeft(2, '0'));
            i += 2;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        case 'd': //日期，必须两个dd
          if ((i + 1 <= lastIndex) && (fmt[i + 1] == 'd')) {
            sb.write(day.toString().padLeft(2, '0'));
            i += 2;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        case 'H': //小时，必须两个HH
          if ((i + 1 <= lastIndex) && (fmt[i + 1] == 'H')) {
            sb.write(hour.toString().padLeft(2, '0'));
            i += 2;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        case 'M': //两个MM为分钟，三个MMM为三个字母表示的月份，四个MMMM为月份全称
          if ((i + 3 <= lastIndex) && (fmt.substring(i, i + 4) == 'MMMM')) {
            var mList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", 
              "October", "November", "December"];
            sb.write(mList[month - DateTime.january]);
            i += 4;
          } else if ((i + 2 <= lastIndex) && (fmt.substring(i, i + 3) == 'MMM')) {
            var mList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            sb.write(mList[month - DateTime.january]);
            i += 3;
          } else if ((i + 1 <= lastIndex) && (fmt[i + 1] == 'M')) {
            sb.write(minute.toString().padLeft(2, '0'));
            i += 2;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        case 'S': //秒，必须两个SS
          if ((i + 1 <= lastIndex) && (fmt[i + 1] == 'S')) {
            sb.write(second.toString().padLeft(2, '0'));
            i += 2;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        case 'E': //EEEE: 英文字母表示的星期, EEE: 三位字母缩写表示的星期
          if ((i + 3 <= lastIndex) && (fmt.substring(i, i + 4) == 'EEEE')) {
            var wList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
            sb.write(wList[weekday - DateTime.monday]);
            i += 4;
          } else if ((i + 2 <= lastIndex) && (fmt.substring(i, i + 3) == 'EEE')) {
            var wList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
            sb.write(wList[weekday - DateTime.monday]);
            i += 3;
          } else {
            sb.write(currChar);
            i++;
          }
          break;
        default:
          sb.write(currChar);
          i++;
      }
    }
    return sb.toString();
  }

  ///返回当天的最早时间
  DateTime firstMoment() => DateTime(year, month, day);
  DateTime lastMoment() => DateTime(year, month, day, 23, 59, 59, 999);

  ///将一个DateTime实例翻译为相对当前时间的直接可读的字符串，比如 1 days ago
  String humanize() {
    // breakPoints 必须是已经排好序的，不然无法进行二分查找
    const breakPoints = [-3600 * 24 * 365, -3600 * 24, -3600, -60, -1, 1, 60, 3600, 3600 * 24, 3600 * 24 * 365];
    const tmpls = ['%s years later', '%s days later', '%s hours later', '%s minutes later', '%s seconds later', 'just now', 
            '%s seconds ago', '%s minutes ago', '%s hours ago', '%s days ago', '%s years ago'];
    
    var seconds = DateTime.now().difference(this).inSeconds; //负数表示将来的时间，正数表示过去的时间
    var point = breakPoints.bisectLeft(seconds);
    var unit = seconds >= 0 ? breakPoints[point - 1] : breakPoints[point];
    return tmpls[point].i18n.fill([(seconds ~/ unit).toString()]);
  }

  //////////////////////////////////////////////////////////
  ///以下是When的静态函数
  static DateTime tomorrow() => DateTime.now().add(const Duration(days: 1));
  static DateTime yesterday() => DateTime.now().subtract(const Duration(days: 1));
  static DateTime theDayBeforeYesterday() => DateTime.now().subtract(const Duration(days: 2));
  static DateTime firstDayOfThisWeek([int firstDayIndexOfWeek=DateTime.monday]) {
    var now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - firstDayIndexOfWeek));
  }
  
  ///上个月的最后一天
  static DateTime lastDayOfLastMonth() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, 0);
  }

  ///上个月的第一天
  static DateTime firstDayOfLastMonth() {
    var now = DateTime.now();
    return DateTime(now.year, now.month - 1, 1);
  }

  ///本月的第一天
  static DateTime firstDayOfThisMonth() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  ///本月的最后一天
  static DateTime lastDayOfThisMonth() {
    var now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }

  ///某一个月的最后一天
  static DateTime lastDayOfTheMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0);
  }

  ///返回上个月的第一天和最后一天
  static List<DateTime> lastMonth() {
    return [firstDayOfLastMonth(), lastDayOfLastMonth()];
  }

  ///本季度的第一天
  static DateTime firstDayOfThisQuarter() {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    
    if ((month >= 1) && (month <= 3)) {
      return DateTime(year, 1, 1);
    } else if ((month >= 4) && (month <= 6)) {
      return DateTime(year, 4, 1);
    } else if ((month >= 7) && (month <= 9)) {
      return DateTime(year, 7, 1);
    } else {
      return DateTime(year, 10, 1);
    }
  }

  ///今年的第一天
  static DateTime firstDayOfThisYear() {
    var now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  ///返回去年的第一天和最后一天
  static List<DateTime> lastYear() {
    var now = DateTime.now();
    return [DateTime(now.year - 1, 1, 1), DateTime(now.year - 1, 12, 31)];
  }

  ///分析RFC 7232, section 2.2: Last-Modified格式的日期
  ///Last-Modified: Wed, 21 Oct 2015 07:28:00 GMT
  static DateTime parseLastModifiedTime(String text) {
    text = text.replaceAll(' ', '');
    if (text.length < 21) {
      return DateTime(1970);
    }
    //var weekday = text.substring(0, 3);
    int? day = int.tryParse(text.substring(4, 6));
    var monthText = text.substring(6, 9);
    int? year = int.tryParse(text.substring(9, 13));
    int? hour = int.tryParse(text.substring(13, 15));
    int? minute = int.tryParse(text.substring(16, 18));
    int? second = int.tryParse(text.substring(19, 21));

    var monthList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    if (!monthList.contains(monthText) || (day == null) || (year == null) || (hour == null) || 
      (minute == null) || (second == null)) {
      return DateTime(1970);
    }

    return DateTime(year, monthList.indexOf(monthText) + 1, day, hour, minute, second);
  }

  ///简单的分析时分秒结构的字符串: 12:01:01
  static DateTime parseTimeOnly(String text) {
    int? second = 0;
    int? minute = 0;
    int? hour = 0;
    final invalidTime = DateTime(1970);
    if (text.isEmpty) {
      return invalidTime;
    }

    final tList = text.split(":");
    if (tList.length == 1) { //仅一个元素，当作秒，不能超过60
      second = int.tryParse(tList.first);
    } else if (tList.length == 2) { //两个元素，当作分钟和秒
      minute = int.tryParse(tList.first);
      second = int.tryParse(tList.last);
    } else if (tList.length == 3) { //三个元素，时分秒
      hour = int.tryParse(tList.first);
      minute = int.tryParse(tList[1]);
      second = int.tryParse(tList.last);
    } else {
      hour = null;
    }

    if ((hour != null) && (minute != null) && (second != null) 
      && (hour >= 0) && (hour < 23)
      && (minute >= 0) && (minute < 60) && (second >= 0) && (second < 60)) {
      return DateTime(2022, 1, 1, hour, minute, second);
    } else {
      return invalidTime;
    }
  }
}
