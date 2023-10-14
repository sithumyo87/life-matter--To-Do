import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sql_test/controller/cubit/cubit.dart';
import 'package:sql_test/controller/cubit/states.dart';
import 'package:sql_test/screen/component.dart';
import 'package:sql_test/view/drawer_screen.dart';
import 'package:sql_test/view/home_screen.dart';


class AddTestScreen extends StatelessWidget {
   AddTestScreen({Key? key}) : super(key: key);

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
        listener: (BuildContext context, state){
      if (state is InsertTodoDatabaseState) {
        Navigator.pop(context);
      }
    }, builder: (BuildContext context, Object? state) {
      var cubit = TodoCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Task".tr(),
            style: TextStyle(color: Colors.deepOrange),
            
          ),
          iconTheme: IconThemeData(color: Colors.deepOrange),
        ),
       
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please Add Title".tr();
                        }
                      },
                      label: 'Title'.tr(),
                      hintText: 'Add Your Title'.tr(),
                      prefixIcon: Icons.label),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      controller: timeController,
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please Add Time".tr();
                        }
                      },
                      label: 'Time'.tr(),
                      hintText: 'Add Your Time'.tr(),
                      prefixIcon: Icons.watch,
                      onTap: () {
                        showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) {
                          timeController.text = value!.format(context);
                        }).catchError((error) {
                          print(error);
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: dateController,
                    keyboardType: TextInputType.text,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please Add Date".tr();
                      }
                    },
                    label: 'Date'.tr(),
                    hintText: 'Add Your Date'.tr(),
                    prefixIcon: Icons.date_range_outlined,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2040-12-30'))
                          .then((value) {
                        dateController.text = DateFormat.yMMMd().format(value!);
                      }).catchError((error) {
                        print(error);
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      lines: 6,
                      controller: descController,
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please Add Description".tr();
                        }
                      },
                      label: 'Description'.tr(),
                      hintText: 'Add Your Description'.tr(),
                      prefixIcon: Icons.label),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.deepOrange,
                      onPressed: () {
                        
                       if(_formkey.currentState!.validate()){
                         cubit.insertDatabase(
                            title: titleController.text,
                            date: dateController.text,
                            time: timeController.text,
                            description: descController.text);
                       }      
                      },
                      child: Text("Submit".tr()))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

