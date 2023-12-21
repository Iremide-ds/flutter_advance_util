extension StringX on String {
  String get formatText => length < 2 ? '0$this' : this;
}
