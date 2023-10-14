import 'package:animated_conditional_builder/animated_conditional_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_test/app_cubit/app_cubit.dart';
import 'package:sql_test/app_cubit/app_states.dart';
import 'package:sql_test/controller/cubit/cubit.dart';
import 'package:sql_test/controller/cubit/states.dart';
import 'package:sql_test/view/add_todo_screen.dart';
import 'package:sql_test/view/drawer_screen.dart';
import 'package:sql_test/view/update_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          
          var cubit = TodoCubit.get(context);
          return Scaffold(
            drawer: const Drawer(
              child: DrawerScreen(),
            ),
            appBar: AppBar(
              title: Text(
                "LIFE MATTER",
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.deepOrange),
              actions: [
                BlocConsumer<AppCubit, AppStates>(
                  listener: (BuildContext context, state) {},
                  builder: (BuildContext context, Object? state) {
                    return IconButton(
                      onPressed: () {
                        BlocProvider.of<AppCubit>(context).changeThemeMode();
                      },
                      icon: Icon( BlocProvider.of<AppCubit>(context).isDark
                          ? Icons.light_mode
                          : Icons.dark_mode));
                  }
                  
                ),
              ],
            ),
            body: AnimatedConditionalBuilder(
              condition: state is! LoadingDataFromDatabaseState,
              fallback: (BuildContext context) =>
                  const Center(child: CircularProgressIndicator()),
              builder: (BuildContext context) {
                return (cubit.tasks.isNotEmpty)
                    ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                      child: ListView.builder(
                          itemCount: cubit.tasks.length,
                          itemBuilder: (BuildContext context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  print(cubit.tasks[index]['id']);
                                  print(cubit.tasks[index]['title']);
                                  print(cubit.tasks[index]['time']);
                                  print(cubit.tasks[index]['date']);
                                  print(cubit.tasks[index]['description']);
                            
                                  return UpdateTodoScreen(
                                      id: cubit.tasks[index]['id'],
                                      title: cubit.tasks[index]['title'],
                                      time: cubit.tasks[index]['time'],
                                      date: cubit.tasks[index]['date'],
                                      desc: cubit.tasks[index]['description']);
                                }));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cubit.tasks[index]['title'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              Text(
                                                cubit.tasks[index]['time'] +'/' +  cubit.tasks[index]['date'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              ),
                                             
                                              IconButton(
                                                  onPressed: () {
                                                    cubit.deleteDataFromDatabase(
                                                        id: cubit.tasks[index]
                                                            ['id']);
                                                  },
                                                  icon: const Icon(Icons.delete))
                                            ]),
                                        Text(
                                          cubit.tasks[index]['description'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.hourglass_empty),
                            Text(
                              'There is no tasks here'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.deepOrange),
                            )
                          ],
                        ),
                      );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return AddTestScreen();
                }));
              },
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
