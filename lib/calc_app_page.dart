import 'package:flutter/material.dart';
import 'package:calc_app/calc_app_model.dart';
import 'package:calc_app/values/calc_app_values.dart';
import 'package:calc_app/values/color_values.dart';

class CalcApp extends StatelessWidget {
  const CalcApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculation Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalcAppPage(title: 'Calc App Page'),
    );
  }
}

class CalcAppPage extends StatefulWidget {
  const CalcAppPage({super.key, required this.title});

  final String title;

  @override
  State<CalcAppPage> createState() => _CalcAppPageState();
}

class _CalcAppPageState extends State<CalcAppPage> {
  final CalcAppModel _calcAppModel = CalcAppModel();

  final List<String> _buttonList = [
    'AC', '', '', '',
    '7', '8', '9', '',
    '4', '5', '6', '',
    '1', '2', '3', '+',
    '0', '', '', '='
  ];

  final List<String> _numberList = [
    '0', '1' ,'2', '3', '4', '5', '6', '7', '8', '9'
  ];

  Color _buttonColor(int index) {
    Color buttonColor;
    if ((index+1)%CalcAppValues.buttonColumns == 0) {
      buttonColor = ButtonColors.calculation;
    } else if(_numberList.contains(_buttonList[index]) || index == 17 || index == 18) {
      buttonColor = ButtonColors.number;
    } else {
      buttonColor = ButtonColors.other;
    }
    return buttonColor;
  }

  void _buttonTapped(int index) {

    if (_calcAppModel.isErrorStatel) {
      debugPrint('Equal pressed state, input ignored.'); // イコール押下状態の場合は入力を無視
      return;
    }

    String button = _buttonList[index];

    if (button == 'AC') {
      debugPrint('tapped all clear');
      _initializeValues();
      _refreshScreen();
    } else if (button == '+') {
      //'+'ボタン押下の場合
      debugPrint('tapped plus');
      _calcAppModel.calculation = '+';
      if (_calcAppModel.currentValue[1].isEmpty) {
        //currentValue[1]に数字が何も入っていなかった場合、処理終了
        return;
      } else {
        try {
          //_calculateSumを呼び出して計算結果を取得
          String totalSum = _calculateSum(_calcAppModel.currentValue);
          //計算結果をdisplayに表示
          _calcAppModel.display = totalSum;
          //計算結果を１つ目格納
          _calcAppModel.currentValue[0] = totalSum;
          //２つ目の値を初期化
          _calcAppModel.currentValue[1] = '';
        } catch (e) {
          _calcAppModel.display = 'E001';
          _calcAppModel.isErrorStatel = true;
        }
      }
      _refreshScreen();
    }
    else if (button == '=') {
      //'='ボタン押下の場合
      debugPrint('tapped equal');
      //calculationに'+'が入っている場合
      if (_calcAppModel.calculation == '+') {
        //1つ目の値がが空の場合、'0'を設定
        if (_calcAppModel.currentValue[1].isEmpty) {
          _calcAppModel.currentValue[1] = '0';
        }
        //_calculateSumを呼び出して計算結果を取得
        String totalSum = _calculateSum(_calcAppModel.currentValue);
        try {
          _calcAppModel.display = totalSum;
        } catch (e) {
          _calcAppModel.display = 'E001';
        };
      }else{
        //calculationに'+'が入っていない場合
        String totalSum = _calcAppModel.currentValue[0];
        // 1つ目の値をそのまま表示
        _calcAppModel.display = totalSum;
      }
      //'='押下後はボタンを押しても反応しなくなる
      _calcAppModel.isErrorStatel = true;
      _refreshScreen();

    } else if(_numberList.contains(button)) {
      //数字ボタン押下の場合
      debugPrint('tapped number');
      //'+'が入力されているかを確認し、数字を格納するリストを決める
      int valueIndex = _calcAppModel.calculation == '+' ? 1 : 0;
      if (_calcAppModel.currentValue[valueIndex] == '0') {
        //先頭が'0'の場合、入力された値を上書き
        _calcAppModel.currentValue[valueIndex] = button;
      } else {
        //先頭が'0'でない場合、入力された値を右に追加
        _calcAppModel.currentValue[valueIndex] += button;
      }
      //入力された桁数をnumberDigitに上書き
      int numberDigit = _calcAppModel.currentValue[valueIndex].length;
      if (numberDigit < 10) {
        //桁数が10桁より少ない場合、画面に表示
        _calcAppModel.display = _calcAppModel.currentValue[valueIndex];
      } else {
        //10桁より多い場合、E001を表示
        _calcAppModel.display = 'E001';
        _calcAppModel.isErrorStatel = true;
      }
      _refreshScreen();
    } else {
      debugPrint('tapped other');
    }
  }

  String _calculateSum(List<String> currentValue) {
    debugPrint('Before calculation - currentValue[0]: ${currentValue[0]}, currentValue[1]: ${currentValue[1]}');
    //リストをint型に変換
    int currentValue1 = int.parse(currentValue[0]);
    int currentValue2 = int.parse(currentValue[1]);
    int sum = currentValue1 + currentValue2;
    debugPrint('Calculation Formula: $currentValue1 + $currentValue2');
    //合計を文字列に変換
    String totalSum = sum.toString();
    //合計の桁数を取得
    int numberDigit = totalSum.length;

    //桁数が10以上かどうかをチェック
    if (numberDigit >= 10) {
      // 桁数10桁以上である場合に例外をスロー
      throw Exception('sum length exceeds limit');
    } else {
      //桁数が9桁以下の場合、合計を文字列として返す
      return totalSum;
    }
  }


  void _initializeValues() {
    _calcAppModel.currentValue[0] = '';
    _calcAppModel.currentValue[1] = '';
    _calcAppModel.calculation = '';
    _calcAppModel.isErrorStatel = false;
    _calcAppModel.display = '0';
    debugPrint('Values initialized');
  }


  void _refreshScreen() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColors.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: BackgroundColors.primary,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: CalcAppValues.displayPadding),
                child: Text(
                  _calcAppModel.display,
                  style: const TextStyle(fontSize: CalcAppValues.displayTextSize, color: FontColors.displayText),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: GridView.builder(
                itemCount: _buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: CalcAppValues.buttonColumns,
                  mainAxisSpacing: CalcAppValues.buttonSpacing,
                  crossAxisSpacing: CalcAppValues.buttonSpacing,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        _buttonTapped(index);
                      },
                      child: Container(
                        color : _buttonColor(index),
                        child: Center(
                          child: Text(
                            _buttonList[index],
                            style: const TextStyle(fontSize: CalcAppValues.buttonTextSize, color: FontColors.buttonText),
                          ),
                        ),
                      )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}