import 'dart:collection';

class RList<E> extends ListBase<E> {
  //List innerList = this;

  //int get length => this.length;

  final List<E> l = [];
  RList();

  set length(int newLength) { l.length = newLength; }
  int get length => l.length;
  E operator [](int index) => l[index];
  void operator []=(int index, E value) { l[index] = value; }

  /*bool remove(Object element) {
    for (int i = 0; i < l.length; i++) {
      print("re");
      if (l[i] == element) {
        print("removeu sim");
        this._closeGap(i, i + 1);
        return true;
      }
    }
    return false;
  }

  void _closeGap(int start, int end) {
    int length = l.length;
    assert(0 <= start);
    assert(start < end);
    assert(end <= length);
    int size = end - start;
    for (int i = end; i < length; i++) {
      l[i - size] = l[i];
    }
    l.length = length - size;
  }*/

  int _totalRecords = 0;

  int get totalRecords => _totalRecords;

  set totalRecords(int totalRecords) {
    _totalRecords = totalRecords;
  }
}
