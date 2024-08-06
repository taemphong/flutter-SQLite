import 'package:flutter/material.dart';
import 'package:project_final/screen/add_employee_screen.dart';
import 'package:project_final/screen/edit_employee_screen.dart';

import '../screen/home_screen.dart';

class RoutGenerrator {
  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/add_employee':
        return MaterialPageRoute(builder: (_) => const AddEmployeeScreen());
      case '/edit_employee':
  if (args is int) {
    return MaterialPageRoute(
      builder: (_) => EditEmployeeScreen(key: ValueKey<int>(args), id: args),
    );
  }
  return _errorRoute();

        

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
        title: const Text('No Route'),
        centerTitle: true,
        ),
        body: const Center(
          child: Text('Sorry no route was found', style: TextStyle(color: Colors.red, fontSize: 18.0)),
        )
      );
    });
  }
}