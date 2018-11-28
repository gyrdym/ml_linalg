class Range {
  final int start;
  final int end;
  final bool endInclusive;

  Range(this.start, this.end, {this.endInclusive = false}) {
    if (start > end) {
      throw RangeError('`start` must be less than `end`');
    }
  }
}
