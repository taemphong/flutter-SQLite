import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/data/local/db/app_db.dart';
import 'package:project_final/notifier/employee_change_notifier.dart';
import 'package:project_final/widget/custom_date_picker_form_field.dart';
import 'package:project_final/widget/custom_text_form_field.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

class EditEmployeeScreen extends StatefulWidget {
  final int id;
  const EditEmployeeScreen({Key? key, required this.id}) : super(key: key);


  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final _formkey = GlobalKey<FormState>();
 
  late EmployeeData _employeeData;
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

     
    getEmpployee();
  }

  @override
  void dispose() {
    
    _userNameController.dispose();
    _firstNameController.dispose();
    _dateOfBirthController.dispose();
    _employeeChangeNotifier.dispose();
    super.dispose();
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              editEmployee();
            

            }, 
            icon: const Icon(Icons.save)
            ),
            IconButton(
              onPressed: (){
                deleteEmployee();


            },
             icon: const Icon(Icons.delete))
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

 void editEmployee(){
  final isValid = _formkey.currentState?.validate();
  if (isValid != null && isValid){
    final entity = EmployeeCompanion(
    id: drift.Value(widget.id),
        userName: drift.Value(_userNameController.text),
        firstName: drift.Value(_firstNameController.text),
        lastName: drift.Value(_lastNameController.text),
        dateofBirth: drift.Value(_dateofBith!),

            );

            context.read<EmployeeChangeNotifier>().updateEmployee(entity);

            /*Provider.of<AppDb>(context, listen: false).updateEmployee(entity).then((value) => ScaffoldMessenger.of(context)
            .showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.orange,
                content: Text('Employee update : $value',style: TextStyle(color: Colors.white)), 
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                   child: const Text('close',style: TextStyle(color: Colors.white),))

                ],
                )
            ),
            ); */

  }
       
      
 }

 void providerListener(){
  if (_employeeChangeNotifier.isUpdated){
    listenUpdate();
  }
  if (_employeeChangeNotifier.isDeleted){
    listenDelete();
  }
 }

 void deleteEmployee(){
  context.read<EmployeeChangeNotifier>().deleteEmployee(widget.id);
  /*Provider.of<AppDb>(context, listen: false).deleteEmployee(widget.id).then((value) => ScaffoldMessenger.of(context)
            .showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.orange,
                content: Text('Employee delete : $value',style: TextStyle(color: Colors.white)), 
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                   child: const Text('close',style: TextStyle(color: Colors.white),))

                ],
                )
            ),
            );*/

 }

 void listenDelete(){
  ScaffoldMessenger.of(context)
  .showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.orange,
                content: const Text('Employee delete : ',style: TextStyle(color: Colors.white)), 
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                   child: const Text('close',style: TextStyle(color: Colors.white),))

                ],
                ),
  );
 }

 void listenUpdate(){
  ScaffoldMessenger.of(context)
            .showMaterialBanner(
              MaterialBanner(
                backgroundColor: Colors.orange,
                content: const Text('Employee update : ',style: TextStyle(color: Colors.white)), 
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                   child: const Text('close',style: TextStyle(color: Colors.white),))

                ],
                )
            );
            
 }

 Future<void> getEmpployee() async {
  _employeeData = await Provider.of<AppDb>(context,listen: false).getEmpployee(widget.id);
_userNameController.text = _employeeData.userName;
_firstNameController.text = _employeeData.firstName;
_lastNameController.text = _employeeData.lastName;
_dateOfBirthController.text = _employeeData.dateofBirth.toIso8601String();
 }
}      
      

