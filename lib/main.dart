import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calc_app/calc_app_page.dart';

void main() {
  // 縦画面固定
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const CalcApp());
  });
}

