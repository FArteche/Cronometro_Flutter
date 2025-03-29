import 'dart:async';

import 'package:cronometro/model/timer_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class TimerViewmodel extends ChangeNotifier {
  final TimerModel _timerModel = TimerModel();
  bool _isRunning = false;
  Timer? _timer;
  static const platform = MethodChannel('com.example.cronometro/background');

  int get seconds => _timerModel.seconds;
  bool get isRunning => _isRunning;
  List<int> get voltas => _timerModel.voltas;
  double get progresso => (seconds % 60) / 60.0;

  TimerViewmodel() {
    _syncWithNative();
  }

  Future<void> _syncWithNative() async {
    try {
      final int? backgroundSeconds = await platform.invokeMethod('getSeconds');
      if (backgroundSeconds != null) {
        _timerModel.setSeconds(backgroundSeconds);
        _isRunning = await platform.invokeMethod('isRunning');
        if (_isRunning) {
          _startForegroundTimer();
        }
        notifyListeners();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Erro ao sincronizar com o timer nativo: ${e.message}");
      }
    }
  }

  Future<void> startTimer() async {
    if (!_isRunning) {
      _isRunning = true;
      _startForegroundTimer();
      try {
        await platform.invokeMethod('startTimer', {'seconds': seconds});
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print("Erro ao iniciar o timer nativo: ${e.message}");
        }
      }
      notifyListeners();
    }
  }

  void _startForegroundTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _timerModel.tick();
        notifyListeners();
      },
    );
  }

  Future<void> stopTimer() async {
    _timer?.cancel();
    _isRunning = false;
    try {
      await platform.invokeMethod('stopTimer');
      print("Timer parado com sucesso no nativo");
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Erro ao parar o timer nativo: ${e.message}");
      }
    }
    notifyListeners();
  }

  void resetTimer() async {
    _timer?.cancel();
    _isRunning = false;
    _timerModel.reset();
    try {
      await platform.invokeMethod('resetTimer');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Erro ao resetar o timer nativo: ${e.message}");
      }
    }
    notifyListeners();
  }

  void addVolta() {
    if (_isRunning) {
      _timerModel.addVolta(_timerModel.seconds);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
