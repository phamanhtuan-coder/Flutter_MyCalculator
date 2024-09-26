// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

void main() {
  runApp(const MyCalculator());
}

class MyCalculator extends StatelessWidget {
  const MyCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyCalculatorHome(title: 'Ứng dụng máy tính đơn giản'),
    );
  }
}

class MyCalculatorHome extends StatefulWidget {
  const MyCalculatorHome({super.key, required this.title});
  final String title;

  @override
  State<MyCalculatorHome> createState() => _MyCalculatorHomeState();
}

class _MyCalculatorHomeState extends State<MyCalculatorHome> {
  String _display = '';
  String _operator = '';
  bool _operatorPressed = false;

  void _onPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '';
        _operator = '';
        _operatorPressed = false;
      } else if (value == '=') {
        _equalPressed();
      } else if ('+-*/'.contains(value)) {
        if (_operatorPressed) {
          if (_operator == value) {
          } else {
            _display = _display.substring(0, _display.length - 1) + value;
            _operator = value;
          }
        } else {
          _display += value;
          _operator = value;
          _operatorPressed = true;
        }
      } else {
        _display += value;
      }
    });
  }

  void _equalPressed() {
    if (_display.isEmpty) {
      return;
    }

    if (_operatorPressed) {
      List<String> parts = _display.split(_operator);
      if (parts.length < 2 || parts[1].isEmpty) {
        _thongBaoLoi('Input không hợp lệ');
        setState(() {
          _display = '';
          _operator = '';
          _operatorPressed = false;
        });
        return;
      }

      double num1 = double.parse(parts[0]);
      double num2 = double.parse(parts[1]);
      double result;

      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            _thongBaoLoi('Không thể chia cho 0');
            setState(() {
              _display = '';
              _operator = '';
              _operatorPressed = false;
            });
            return;
          }
          break;
        default:
          result = 0;
      }

      setState(() {
        _display = result.toString();
        _operator = '';
        _operatorPressed = false;
      });
    } else {
      setState(() {
        _display = "";
      });
    }
  }

  void _thongBaoLoi(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.calculate, color: Colors.white),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/'),
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*'),
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
                _buildButton('0'),
                _buildButton('C'),
                _buildButton('='),
                _buildButton('+'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onPressed(value),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20.0),
        ),
        child: Text(
          value,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
