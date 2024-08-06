import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:project_final/notifier/employee_change_notifier.dart';
import 'package:project_final/route/route_generator.dart';
import 'package:project_final/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    
    MultiProvider(
      providers: [
        Provider.value(value: AppDb()), 
        ChangeNotifierProxyProvider<AppDb, EmployeeChangeNotifier>(
          create: (context) => EmployeeChangeNotifier(),
          update: (context, db, notifier) => notifier!..initAppDb(db)..getEmployeeFuture()),
      ],
      child: const MyApp(),
    )
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
       

       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: RoutGenerrator.generateRoute,
      home: const HomeScreen(),
    );
  }
}

