/// m328v6数控电子负载上位机
/// 存放下位机发送给上位机的数据缓存，为一个环形缓冲区
/// Author: cdhigh <https://github.com/cdhigh>
/// 
import 'dart:typed_data';

class SerialRespBuffer {
  final Uint8List _buf;
  final int _capacity;
  int _start = 0;
  int _end = -1;
  int _count = 0;
  int _packageCount = 0;  //回复包的个数，每个回复包由回车换行分开
  int _prevChar = 0; //前一个字节，用于判断是否是回车换行

  /// Creates a [SerialRespBuffer] with a `capacity`
  SerialRespBuffer(int capacity) : assert(capacity > 1), _capacity = capacity, _buf = Uint8List(capacity);

  /// The [SerialRespBuffer] is `reset`
  void reset() {
    _start = 0;
    _end = -1;
    _count = 0;
    _packageCount = 0;
    _prevChar = 0;
    for (var idx = 0; idx < _capacity; idx++) {
      _buf[idx] = 0;
    }
  }

  ///往缓冲区中添加一个数据
  void add(int elem) {
    //下位机仅会上传ASCII字符（需要包括0x0d/0x0a）
    if ((elem < 0x0a) || (elem > 0x7e) || isFull) {
      return;
    }

    // Adding the next value
    _end++;
    if (_end >= _capacity) {
      _end = 0;
    }

    _buf[_end] = elem;
    _count++;
    
    //判断回复包的分隔标识回车换行
    if ((_prevChar == 0x0d) && (elem == 0x0a)) {
      _packageCount++;
    }
    _prevChar = elem;
  }

  ///将一个列表中的所有元素添加到环形列表
  void addAll(Uint8List data) {
    for (final elem in data) {
      add(elem);
    }
  }

  ///获取一个完整的回复包，包含回车换行
  List<int> getOnePackage() {
    final ret = <int>[];
    if (_packageCount <= 0) {
      return ret;
    }

    int prev = _buf[_start];
    int curr;
    while (_count > 0) {
      curr = _buf[_start];
      //_buf[_start] = 0;
      _count--;
      _start++;
      if (_start >= _capacity) {
        _start = 0;
      }

      ret.add(curr);
      if ((prev == 0x0d) && (curr == 0x0a)) { //判断回复包的分隔标识回车换行
        break;
      }
      prev = curr;
    }

    _packageCount--;

    //校验包的完整性
    if (ret.last == 0x0a) {
      return ret;
    } else {
      return <int>[];
    }
  }

  ///缓冲区中的元素个数
  int get length => _count;

  ///缓冲区中的回复包个数
  int get packageCount => _packageCount;

  ///缓冲区的容量
  int get capacity => _capacity;

  ///缓冲区是否已经满
  bool get isFull => _count >= _capacity;
}
