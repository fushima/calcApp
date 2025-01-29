class CalcAppModel {
  final List<String> _currentValue = ['', ''];
  String _calculation = '';
  String _display = '';
  bool _isErrorStatel = false;

  List<String> get currentValue => _currentValue;

  String get display => _display.isEmpty ? '0' : _display;

  set display(String value) {
    if (value.isEmpty) {
      _display = '0';
    } else {
      _display = value;
    }
  }

  String get calculation => _calculation;

  set calculation(String value) {
    _calculation = value;
  }

  bool get isErrorStatel => _isErrorStatel;

  set isErrorStatel(bool value) {
    _isErrorStatel = value;
  }
}
