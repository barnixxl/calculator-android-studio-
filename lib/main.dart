import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // незименяемый виджет
  const MyApp({super.key}); // передаем ключ род классу

  @override // переопределяем метод родительского класса
  Widget build(BuildContext context) { // возвращаем интерфейс, где каждый виджет имеет метод build
    return MaterialApp( // корневой виджет
      title: 'калькулятор',
      theme: ThemeData( // тема оформления всего приложенния
        primarySwatch: Colors.blue,
        useMaterial3: true, // применяемый дизайн
      ),
      home: const Calculate(), // главный виджет - главный экран
    );
  }
}

class Calculate extends StatefulWidget{ // класс с изменяемыми виджетами
  const Calculate({super.key}); // создаем через конструктор экземпляр класса

  @override
  State<Calculate> createState() => _CalculateState(); // создаем состояние виджета и объект состояния

}

class _CalculateState extends State<Calculate>{ // приватный класс состояние с передаваемым значением состояния State<Calculate>
  String display = '0'; // создаем переменные, которые будут менять состояние
  double firstNum = 0;
  double secondNum = 0;
  String operation = '';
  bool newNum = true; // если true - следующая цифра, если false, то добавляем цифру к текущему

  void numPress(String digit){ // метод нажатия цифр
    setState(() { // функция для изменения интерфейса
      if(newNum || display == '0'){ // запись цифры в строку (проверка на то что экран пуст)
        display = digit; // добавляем цифру на экран в виде строки
        newNum = false; // переводим состояние для добавления цифры или операции
      }
      else{
        display = display + digit; // если уже есть число, например 2, то след нажатая цифра добавиться к 2ойке
      }
    });
  }

  void operationPress(String oper){ // метод для обработки нажатой операции
    setState(() { // изменение интерфейса
      firstNum = double.parse(display); // преобразуем текст (наши первые цифры) в числовое знаечние дабл
      operation = oper; // присваиваем выбранную операцию
      newNum = true; // для записи второго числа в операции
    });
  }

  void writeResult(){ // вывод результата
    setState(() {
      secondNum = double.parse(display); // преобразуем второе число из строкового в дабл тип

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

  Color _buttonColor(String text){ // метод для цвета кнопок
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
        return Colors.grey; // для цифр
    }
  }

  void _display(String text){ // обработчик операций
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

  Widget _buildButton(String text) { // создаение кнопок
    return Expanded( // растягиваем кнопки в таблице
      child: Padding( // добавляем отступы
        padding: const EdgeInsets.all(6), // 6 пикселей со всех сторон отступа
        child: ElevatedButton( // создаем кнопку с оформлением
          onPressed: () => _display(text), // объявление функции нажатия и вывода действия в строку
          style: ElevatedButton.styleFrom( // внешний вид кнопки
            backgroundColor: _buttonColor(text), // метод с переопределением цвета кнопки в зависимости от типа
            foregroundColor: Colors.white, // цвет текста
            padding: const EdgeInsets.all(20), // отступы внутри кнопки
            shape: RoundedRectangleBorder( // закругленные кнопки
              borderRadius: BorderRadius.circular(10), // радиус завертки
            ),
          ),
          child: Text( // текст внутри кнопки - что будет внутри
            text, // передаваемый параметр
            style: const TextStyle(fontSize: 24), // размер
          ),
        ),
      ),
    );
  }

 Widget _buttonRow(List<String> buttons){ // создание ряда кнопок
    return Expanded( // расстяжение по высоте
      child: Row( // создание строки
        children: buttons.map( // для каждой строки присваеваем кнопку
                (text) => _buildButton(text) // вставляем кнопку с текстом
        ).toList(), // преобразуем в лист
      ),
    );
  }

  @override
  Widget build(BuildContext context) { // построение интерфейса  возвращаем созданные виджеты
    return Scaffold( // базовое строение интерфейса, применяющее структуру с app body и тд
      appBar: AppBar( // верхняя часть
        title: const Text('калькулятор'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column( // вертикальное расположение элементов
        children: [ // список дочерних виджетов
          Expanded( // растяжение
            flex: 2, // сила растяжения
            child: Container( // контейнер с описанием
              color: Colors.grey[100], // цвет цифр
              child: Padding( // отступы от дисплея
                padding: const EdgeInsets.all(16), // 16 со всех сторон
                child: Align( // размещение текста в нужную позицию
                  alignment: Alignment.bottomRight, // позиция выравнивания
                  child: Text( // текст дисплея
                    display, // текущее значение
                    style: const TextStyle( // стиль текста
                      fontSize: 60, // размер текста
                      fontWeight: FontWeight.bold, // жирность
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded( // виджет с растяжением и кнопками
            flex: 5, // коэф расстяжения ( 7 частей экрана - 2 силы расстяжения)
            child: Column( // колонка для кнопок
              children: [ // список рядов
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