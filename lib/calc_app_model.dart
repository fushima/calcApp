
class CalcAppModel {
  final List<String> _currentValue = ['', ''];
  final String _calculation = '';
  final String _display = '';
  final bool _isEqualPressed = false;

  String get display => _display.isEmpty ? '0' : _display;

}