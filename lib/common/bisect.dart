/// Bisection algorithms translated from [Python's standard library]
/// (https://docs.python.org/3/library/bisect.html).
///https://github.com/Israel77/Bisect/blob/master/lib/bisect.dart

extension Bisect<E> on List<E> {
  /// Inserts an [element] to a sorted [list] while keeping it sorted,
  /// assuming this [list] is already sorted.
  ///
  /// If the [element] is already on this [list], it is inserted in the
  /// rightmost possible position.
  ///
  /// Optional parameters works the same as in [bisectRight].
  ///
  /// Equivalent to:
  /// `list.insert(list.bisectRight(element), element)`
  void insortRight(E element, {int Function(E, E)? compare, int low = 0, int? high}) {
    low = bisectRight(element, compare: compare, low: low, high: high);
    insert(low, element);
  }

  /// Returns the index where an element should be inserted in a [list],
  /// assuming the [list] is sorted by a [compare] function.
  ///
  /// If this [element] is already in this [list],returns the rightmost index
  /// where it can be inserted.
  ///
  /// The [compare] function must act as a [Comparator].
  ///
  /// The default implementation uses [Comparable.compare] if [compare]
  /// is omitted.
  ///
  /// Two optional parameters [low] (`0` by default) and [high] (`list.length` by default)
  /// can be provided to bisect only an slice of this list where the element will be inserted.
  int bisectRight(E element, {int Function(E, E)? compare, int low = 0, int? high}) {
    compare ??= Comparable.compare as int Function(E, E);
    high ??= length;

    if (low < 0) {
      throw ArgumentError('low must be non-negative');
    }

    // This algorithm is very similar to a binary search.
    while (low < high!) {
      // At each iteration the algorithm looks at a slice of this list
      // where the element can be inserted, and divides it in half.
      var mid = (low + high) ~/ 2;

      // Then the algorithm compares the element to be inserted to
      // the middle element.
      if (compare(element, this[mid]) < 0) {
        // If the element to be inserted is smaller than the middle
        // element, then in the next iteration we only need to look
        // between the start of the current slice and the middle element.
        high = mid;
      } else {
        // Otherwise the algorithm will look between the element next
        // to the middle one and the end of the current slice.
        low = mid + 1;
      }
    }

    return low;
  }

  /// Inserts an [element] to a sorted [list] while keeping it sorted,
  /// assuming this [list] is already sorted.
  ///
  /// If the [element] is already on this [list], it is inserted in the
  /// leftmost possible position.
  ///
  /// Optional parameters works the same as in [bisectLeft].
  ///
  /// Equivalent to:
  /// `list.insert(list.bisectLeft(element), element)`
  void insortLeft(E element, {int Function(E, E)? compare, int low = 0, int? high}) {
    low = bisectLeft(element, compare: compare, low: low, high: high);
    insert(low, element);
  }

  /// Returns the index where an element should be inserted in a [list],
  /// assuming the [list] is sorted by a [compare] function.
  ///
  /// If this [element] is already in this [list],returns the leftmost index
  /// where it can be inserted.
  ///
  /// The [compare] function must act as a [Comparator].
  ///
  /// The default implementation uses [Comparable.compare] if [compare]
  /// is omitted.
  ///
  /// Two optional parameters [low] (`0` by default) and [high] (`list.length` by default)
  /// can be provided to bisect only an slice of this list where the element will be inserted.
  int bisectLeft(E element, {int Function(E, E)? compare, int low = 0, int? high}) {
    compare ??= Comparable.compare as int Function(E, E);
    high ??= length;

    if (low < 0) {
      throw ArgumentError('low must be non-negative');
    }

    // This algorithm is identical to bisectRight with only
    // a minor tweak, so when the element is found on the list
    // it is inserted to the leftmost position.
    while (low < high!) {
      var mid = (low + high) ~/ 2;
      if (compare(this[mid], element) < 0) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    return low;
  }

  // Aliases

  /// Just and alias for [bisectRight].
  int bisect(E element, {int Function(E, E)? compare, int low = 0, int? high}) =>
      bisectRight(element, compare: compare, low: low, high: high);

  /// Just an alias for [insortRight].
  void insort(E element, {int Function(E, E)? compare, int low = 0, int? high}) {
    insortRight(element, compare: compare, low: low, high: high);
  }
}
