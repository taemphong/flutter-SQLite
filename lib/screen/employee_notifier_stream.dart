
import 'package:flutter/material.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:project_final/notifier/employee_change_notifier.dart';
import 'package:provider/provider.dart';

class EmployeeNotifierStreamScreen extends StatefulWidget {
  const EmployeeNotifierStreamScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeNotifierStreamScreen> createState() => _EmployeeNotifierStreamScreenState();
}

class _EmployeeNotifierStreamScreenState extends State<EmployeeNotifierStreamScreen> {
  EmployeeChangeNotifier? _employeeChangeNotifier; // ประกาศตัวแปร _employeeChangeNotifier

  @override
  void initState() {
    super.initState();

    _employeeChangeNotifier = Provider.of<EmployeeChangeNotifier>(context, listen: false);
    _employeeChangeNotifier!.addListener(providerListener);
  }

  @override
  void dispose() {
    // ตรวจสอบว่า _employeeChangeNotifier ไม่เป็น null ก่อนที่จะเรียก dispose
    if (_employeeChangeNotifier != null) {
      _employeeChangeNotifier!.removeListener(providerListener);
    }
    super.dispose();
  }

  void providerListener() {
    if (_employeeChangeNotifier!.isAdded) {
      // ตรวจสอบว่า _employeeChangeNotifier ไม่เป็น null ก่อนที่จะทำอะไรก็ตาม
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.orange,
          content: const Text('New employee inserted:', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('close', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Stream BuildContext');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Stream'),
        centerTitle: true,
      ),
      body: Selector<EmployeeChangeNotifier, List<EmployeeData>>(
        selector: (context, notifier) => notifier.employeeListStream,
        builder: (context, employees, child) {
          debugPrint('Selector BuildContext');
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/edit_employee', arguments: employee.id);
                },
                child: Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.green,
                      style: BorderStyle.solid,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${employee.id}'),
                        Text('Username: ${employee.userName}'),
                        Text('First Name: ${employee.firstName}'),
                        Text('Last Name: ${employee.lastName}'),
                        Text('Date of Birth: ${employee.dateofBirth}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
