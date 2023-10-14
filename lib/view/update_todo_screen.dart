import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sql_test/screen/component.dart';

import '../controller/cubit/cubit.dart';
import '../controller/cubit/states.dart';

class UpdateTodoScreen extends StatefulWidget {
  final int id;
  const UpdateTodoScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.time,
      required this.date,
      required this.desc})
      : super(key: key);
  final String title;
  final String time;
  final String date;
  final String desc;

  @override
  State<UpdateTodoScreen> createState() => _UpdateTodoScreenState();
}

class _UpdateTodoScreenState extends State<UpdateTodoScreen> {
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final descController = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    print(titleController.text);
    titleController.text = widget.title;
    timeController.text = widget.time;
    dateController.text = widget.date;
    descController.text = widget.desc;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
        listener: (BuildContext context, state) {
      if (state is UpdateTodoDatabaseState) {
        Navigator.pop(context);
      }
    }, builder: (BuildContext context, Object? state) {
      var cubit = TodoCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Update Task".tr(),
            style: TextStyle(color: Colors.black),
          ),
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
                          return "Please Update Title".tr();
                        }
                      },
                      label: 'Title'.tr(),
                      hintText: 'Update Your Title'.tr(),
                      prefixIcon: Icons.label),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      controller: timeController,
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Please Update Time".tr();
                        }
                      },
                      label: 'Time'.tr(),
                      hintText: 'Update Your Time'.tr(),
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
                        return "Please Update Date".tr();
                      }
                    },
                    label: 'Date'.tr(),
                    hintText: 'Update Your Date'.tr(),
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
                          return "Please Update Description".tr();
                        }
                      },
                      label: 'Description'.tr(),
                      hintText: 'Update Your Description'.tr(),
                      prefixIcon: Icons.label),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                      minWidth: double.infinity,
                      color: Colors.green,
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          cubit.updateDataFromDatabase(
                              title: titleController.text,
                              date: dateController.text,
                              time: timeController.text,
                              description: descController.text,
                              id: widget.id);
                        }
                      },
                      child: Text("Update".tr()))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
