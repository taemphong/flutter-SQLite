
import 'package:flutter/material.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:project_final/notifier/employee_change_notifier.dart';
import 'package:project_final/screen/employee_future.dart';
import 'package:project_final/screen/employee_notifier_future.dart';
import 'package:project_final/screen/employee_notifier_stream.dart';
import 'package:project_final/screen/employee_stream.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  //late Appdb _db;
  late AppDb _db;
  final pages = const [
    EmployeeNotifierFutureScreen(),
    EmployeeNotifierStreamScreen()
    //EmployeeStreamScreen()
  ];

  @override
  void initState() {
    super.initState();

    _db = AppDb();
  }

  @override
  void dispose() {
    super.dispose();
    _db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    body: pages[index],
    
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushNamed(context, '/add_employee');

        },
        icon: const Icon(Icons.add),
         label: const Text('Add Employee')),
         bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (value){
            if (value == 1){
              context.read<EmployeeChangeNotifier>().getEmployeeStream();
            }
            setState(() {
              index = value;
            });
          } ,
          backgroundColor: const Color.fromARGB(255, 4, 118, 211),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white30,
          showSelectedLabels: false,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list_outlined),
              label: 'Employee Future'
              ),
              BottomNavigationBarItem(
              icon: Icon(Icons.list),
              activeIcon: Icon(Icons.list_outlined),
              label: 'Employee Stream'
              ),
          ],),
          
          
    );
  }
}