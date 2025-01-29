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
    String button = _buttonList[index];

    if (button == 'AC') {
      debugPrint('tapped all clear');
    } else if (button == '+') {
      debugPrint('tapped plus');
    } else if (button == '=') {
      debugPrint('tapped equal');
    } else if(_numberList.contains(button)) {
      debugPrint('tapped number');
    } else {
      debugPrint('tapped other');
    }
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
