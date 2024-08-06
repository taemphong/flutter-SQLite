import 'package:flutter/material.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:project_final/notifier/employee_change_notifier.dart';
import 'package:provider/provider.dart';


class EmployeeNotifierFutureScreen extends StatelessWidget {
  const EmployeeNotifierFutureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('BuilContext');
    // ให้คุณใช้งาน EmployeeChangeNotifier ผ่าน Provider.of ใน build method นี้
    final isLoading = context.select<EmployeeChangeNotifier, bool>((notifier) => notifier.isLoading);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Future'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<EmployeeChangeNotifier>(builder: (context, notifier, child) {
              debugPrint('Consumer widget');
              return ListView.builder(
                itemCount: notifier.employeeListFuture.length,
                itemBuilder: (context, index) {
                  final employee = notifier.employeeListFuture[index];
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
            }),
    );
  }
}
