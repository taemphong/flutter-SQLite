
import 'package:flutter/material.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:provider/provider.dart';

class EmployeeFutureScreen extends StatefulWidget {
  const EmployeeFutureScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeFutureScreen> createState() => _EmployeeFutureScreenState();
}

class _EmployeeFutureScreenState extends State<EmployeeFutureScreen> {
  
  

  @override
  void initState() {
    super.initState();

    
  }

  @override
  void dispose() {
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Future'),
        centerTitle: true,
      ),
    body: FutureBuilder<List<EmployeeData>>(
      future: Provider.of<AppDb>(context).getEmployees(),
      builder: (context, snapshot) {
        final List<EmployeeData>? employees = snapshot.data;

        if(snapshot.connectionState != ConnectionState.done){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if(employees != null){
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {

            final employee = employees[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/edit_employee',arguments: employee.id);
              }, 
              child:Card(
            elevation: 2.0, // เพิ่ม elevation เพื่อให้ Card มีเงา
            margin: const EdgeInsets.all(8.0), // เพิ่ม margin เพื่อเพิ่มระยะห่างรอบ Card
            shape: RoundedRectangleBorder(
              side: const BorderSide(
              color: Colors.green,
              style: BorderStyle.solid,
                 width: 1.2,
            ),
            borderRadius: BorderRadius.circular(8.0), // เพิ่มขอบมนเมาท์
            ),
  child: Padding(
    padding: const EdgeInsets.all(8.0), // เพิ่ม padding เพื่อเพิ่มระยะห่างภายใน Card
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // จัดเรียงข้อมูลภายใน Column ไปทางซ้าย
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
          });
        }

        return const Text('No data found');
      },
    ),
      
          
          
    );
  }
}