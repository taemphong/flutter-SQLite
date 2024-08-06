import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:project_final/notifier/employee_change_notifier.dart';
import 'package:project_final/widget/custom_date_picker_form_field.dart';
import 'package:project_final/widget/custom_text_form_field.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formkey = GlobalKey<FormState>();
  
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  DateTime? _dateofBith;
  late EmployeeChangeNotifier _employeeChangeNotifier;

  @override
  void initState() {
    
    super.initState();
    _employeeChangeNotifier = Provider.of<EmployeeChangeNotifier>(context,listen: false);
    _employeeChangeNotifier.addListener(providerListener);

    
  }

  @override
  void dispose() {
    
    _userNameController.dispose();
    _firstNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }
  


  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
             addEmployee();
            }, 
            icon: const Icon(Icons.save)
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [

                  CustomTextFormField(controller: _userNameController, txtLabel: 'User Name', ),
            const SizedBox(height: 8.0,),
            CustomTextFormField(controller: _firstNameController, txtLabel: 'First Name', ),
            const SizedBox(height: 8.0,),
            CustomTextFormField(controller: _lastNameController, txtLabel: 'Last Name', ),
            const SizedBox(height: 8.0,),
           CustomDatePickerFormField(
             controller: _dateOfBirthController,
             txtLabel: 'Date of birth',
            callback: () {
             pickDateofBirth(context);
            }),
              const SizedBox(height: 8.0,),
                ],
                )
              ),
            ],
        ),
      ),
    );
  }

 Future<void> pickDateofBirth(BuildContext context) async {
  final initialDate = DateTime.now();
  final newDate = await showDatePicker(
    context: context,
    initialDate: _dateofBith ?? initialDate,
    firstDate: DateTime(DateTime.now().year - 100),
    lastDate: DateTime(DateTime.now().year + 1),
    locale: const Locale('en', 'US'), // กำหนดภาษาที่ต้องการ
    // คุณสามารถกำหนดวันที่เริ่มต้นเช่นเดียวกับ initialDate ด้วย
    // ในกรณีนี้ค่า initialDatePickerMode ไม่จำเป็น
    // initialDatePickerMode: DatePickerMode.day,
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Colors.pink,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        dialogBackgroundColor: Colors.white,
      ),
      child: child ?? const Text(''),
    ),
  );

  if (newDate == null) {
    return;
  }

  setState(() {
    _dateofBith = newDate;
    String dob = DateFormat('dd/MM/yyyy').format(newDate);
    _dateOfBirthController.text = dob;
  });
}

void addEmployee() {
  final isValid = _formkey.currentState?.validate();

  if (isValid != null && isValid) {
    final entity = EmployeeCompanion(
      userName: drift.Value(_userNameController.text),
      firstName: drift.Value(_firstNameController.text),
      lastName: drift.Value(_lastNameController.text),
      dateofBirth: drift.Value(_dateofBith!),
    );

    context.read<EmployeeChangeNotifier>().createEmployee(entity);
  }
}


            /* Provider.of<AppDb>(context, listen: false).insertEmployee(entity).then((value) => ScaffoldMessenger.of(context)
            .showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.orange,
                content: Text('New employee inserted: $value',style: TextStyle(color: Colors.white)), 
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                   child: const Text('close',style: TextStyle(color: Colors.white),))

                ],
                )
            ),
            ); */
       
      void providerListener() {
  if (_employeeChangeNotifier.isAdded) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.orange,
        content: const Text('New employee inserted', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('close', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

}      
      

