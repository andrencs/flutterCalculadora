class Memory {
  static const OPERATIONS = const ['%', '/', 'x', '-', '+', '='];

  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  String _operation;
  String _value = '0';
  bool _wipeValue = false;
  String _lastCommand;

  void applyCommand(String command) {
    if(_isReplacingOperation(command)){
      _operation = command;
      return;
    }


    if (command == 'AC') {
      _allClear();
    } else if (OPERATIONS.contains(command)) {
      _setOperation(command);
    } else {
      _addDigit(command);
    }

    _lastCommand = command;
  }

  _allClear() {
    _value = '0';
    _buffer[0] = 0;
    _buffer[1] = 0;
    _bufferIndex = 0;
    _operation = null;
    _wipeValue = false;
  }

  _setOperation(String newOperation) {
    bool isEqualSign = newOperation == '=';

    if (_bufferIndex == 0) {
      if(!isEqualSign){
        _operation = newOperation;
        _bufferIndex = 1;
      }
    } else {
      _buffer[0] = _calculate();
      _buffer[1] = 0;
      _value = _buffer[0].toString();
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value;

      _operation = isEqualSign ? null : newOperation;
      _bufferIndex = isEqualSign ? 0 : 1;
    }
    _wipeValue = true;
  }

  _addDigit(String digit) {
    // FIXME: Melhorar essa lógica pois está muito confusa

    final isDot = digit == '.';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue;

    if (isDot && _value.contains('.') && !wipeValue) {
      return;
    }

    final emptyValue = isDot ? '0' : '';
    final currentValue = wipeValue ? '' : value;
    _value = currentValue + digit;
    _wipeValue = false;

    _buffer[_bufferIndex] = double.tryParse(_value) ?? 0;

    print(_buffer);
  }

  _calculate() {
    switch (_operation) {
      case '%':
        return _buffer[0] % _buffer[1];
        break;
      case '/':
        return _buffer[0] / _buffer[1];
        break;
      case 'x':
        return _buffer[0] * _buffer[1];
        break;
      case '-':
        return _buffer[0] - _buffer[1];
        break;
      case '+':
        return _buffer[0] + _buffer[1];
        break;
      case '=':
        return _buffer[0];
        break;
      default:
    }
  }

  _isReplacingOperation(String command){
    return OPERATIONS.contains(_lastCommand)
      && OPERATIONS.contains(command)
      && _lastCommand != '='
      && command != '=';
  }

  String get value {
    return _value;
  }
}
