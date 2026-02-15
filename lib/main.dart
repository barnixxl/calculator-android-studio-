import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'калькулятор',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Calculate(),
    );
  }
}

class Calculate extends StatefulWidget{
  const Calculate({super.key});

  @override
  State<Calculate> createState() => _CalculateState();

}

class _CalculateState extends State<Calculate>{
  String display = '0';
  double firstNum = 0;
  double secondNum = 0;
  String operation = '';
  bool newNum = true;

  void numPress(String digit){
    setState(() {
      if(newNum || display == '0'){
        display = digit;
        newNum = false;
      }
      else{
        display = display + digit;
      }
    });
  }

  void operationPress(String oper){
    setState(() {
      firstNum = double.parse(display);
      operation = oper;
      newNum = true;
    });
  }

  void writeResult(){
    setState(() {
      secondNum = double.parse(display);

      switch (operation){

        case '+':
          display = (firstNum + secondNum).toString();

        case '-':
          display = (firstNum - secondNum).toString();

        case '/':
          if(secondNum == 0){
            display = "ошибка: деление на 0";
            break;
          }
          else {
            display = (firstNum / secondNum).toString();
          }

        case '%':
          display = ((secondNum / 100) * firstNum).toString();

        case '*':
          display = (firstNum * secondNum).toString();

        default:
          return;
      }

      newNum = true;
    });
  }

  void clear(){
    setState(() {
       display = '0';
       firstNum = 0;
       secondNum = 0;
       operation = '';
       newNum = true;
    });
  }

  Color _buttonColor(String text){
    switch (text){
      case 'C':
        return Colors.red;
      case '=':
        return Colors.green;
      case '/':
      case '+':
      case '-':
      case '%':
      case '*':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  void _display(String text){
    if(text == 'C'){
      clear();
    }
    else if(text == '='){
      writeResult();
    }
    else if(text == '/' || text == '+' || text == '-' || text == '%' || text == '*' ){
      operationPress(text);
    }
    else {
      numPress(text);
    }
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () => _display(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: _buttonColor(text),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

 Widget _buttonRow(List<String> buttons){
    return Expanded(
      child: Row(
        children: buttons.map(
                (text) => _buildButton(text)
        ).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('калькулятор'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buttonRow(['C', '/', '%']),
                _buttonRow(['7', '8', '9', '×']),
                _buttonRow(['4', '5', '6', '-']),
                _buttonRow(['1', '2', '3', '+']),
                _buttonRow(['0', '00', '.', '=']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}