import 'package:flutter/material.dart';

void main() {
  runApp(SalaryCalculatorApp());
}

class SalaryCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CustomFont', // Set the custom font family here
      ),
      debugShowCheckedModeBanner: false,
      home: SalaryCalculatorScreen(),
    );
  }
}

class SalaryCalculatorScreen extends StatefulWidget {
  @override
  _SalaryCalculatorScreenState createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _workingHoursController = TextEditingController();
  final TextEditingController _bonusCountController = TextEditingController();
  String _result = '';

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _workingHoursController.dispose();
    _bonusCountController.dispose();
    super.dispose();
  }

  double calculateSalary(int workingHours, int bonusCount) {
    double workingMoney = workingHours * 9000;
    double bonus = bonusCount * 8000;
    double totalIncome = workingMoney + bonus;
    double deduction = totalIncome * 3.3 / 100;
    double salary = totalIncome - deduction;
    return salary;
  }

  void _calculate() {
    final int workingHours = int.tryParse(_workingHoursController.text) ?? 0;
    final int bonusCount = int.tryParse(_bonusCountController.text) ?? 0;

    double salary = calculateSalary(workingHours, bonusCount);
    setState(() {
      _result = 'Your total salary after deduction is: ${salary.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} 원';
    });

    // Trigger the animation
    _animationController.forward(from: 0.0);
  }

  void _reset() {
    _workingHoursController.clear();
    _bonusCountController.clear();
    setState(() {
      _result = '';
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salary Calculator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade100,
              Colors.deepPurple.shade300,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _workingHoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter working hours',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _bonusCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter number of bonuses',
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Calculate Salary'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Button background color for reset
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ScaleTransition(
              scale: _animation,
              child: Text(
                _result,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
