import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefectService {
  static final DefectService _instance = DefectService._internal();
  factory DefectService() => _instance;
  DefectService._internal();

  static const String _keyRunning = 'defect_time_running';
  static const String _keyError = 'defect_time_error';
  static const String _keyActive = 'defect_service_enabled';

  final ValueNotifier<bool> isDefectActive = ValueNotifier<bool>(false);
  
  int _timeRunningMinutes = 30; // Default 30 min
  int _timeErrorMinutes = 5;    // Default 5 min
  bool _isEnabled = false;
  bool _initialized = false;

  Timer? _cycleTimer;

  int get timeRunning => _timeRunningMinutes;
  int get timeError => _timeErrorMinutes;
  bool get isEnabled => _isEnabled;

  Future<void> init() async {
    // Verhindere doppelte Initialisierung (z.B. nach App-Resume)
    if (_initialized) return;
    _initialized = true;
    
    final prefs = await SharedPreferences.getInstance();
    _timeRunningMinutes = prefs.getInt(_keyRunning) ?? 30;
    _timeErrorMinutes = prefs.getInt(_keyError) ?? 5;
    _isEnabled = prefs.getBool(_keyActive) ?? false;

    if (_isEnabled) {
      _startCycle();
    }
  }

  Future<void> updateSettings(int running, int error, bool enabled) async {
    _timeRunningMinutes = running;
    _timeErrorMinutes = error;
    _isEnabled = enabled;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyRunning, running);
    await prefs.setInt(_keyError, error);
    await prefs.setBool(_keyActive, enabled);

    _stopCycle();
    if (_isEnabled) {
      _startCycle();
    } else {
      isDefectActive.value = false;
    }
  }

  void _startCycle() {
    _cycleTimer?.cancel();
    isDefectActive.value = false;
    _scheduleDefect();
  }

  void _scheduleDefect() {
    // Sicherstellen, dass die Zeit mindestens 1 Minute beträgt, um Endlosschleifen zu verhindern
    final duration = Duration(minutes: _timeRunningMinutes > 0 ? _timeRunningMinutes : 1);
    _cycleTimer = Timer(duration, () {
      isDefectActive.value = true;
      _scheduleRecovery();
    });
  }

  void _scheduleRecovery() {
    // Sicherstellen, dass die Zeit mindestens 1 Minute beträgt
    final duration = Duration(minutes: _timeErrorMinutes > 0 ? _timeErrorMinutes : 1);
    _cycleTimer = Timer(duration, () {
      isDefectActive.value = false;
      _scheduleDefect();
    });
  }

  void _stopCycle() {
    _cycleTimer?.cancel();
    _cycleTimer = null;
  }
}
