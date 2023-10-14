import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_test/controller/cubit/states.dart';

class TodoCubit extends Cubit<TodoState>{
  TodoCubit() :super(InitialTodoState());

  static TodoCubit get(context) => BlocProvider.of(context);

  //Sql lite 
  //Create our database
  //Create database file
  //Crate database Table
  //Open Database file
  Database? database;

  void  createDatabase(){
    openDatabase('dbnew4.db',
      version:1,
      onCreate:(database,version){
        //here 
        print("The database is created");
        database.execute('CREATE TABLE tasks'
        '(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,description TEXT,status TEXT)').then((value){
            print('our database is created');
        }).catchError((error){
          print('an error when creating table');
        });
      },
      onOpen:(database){
        print('database file is opened');
        gettingDataFromDatabase(database);
      }
    ).then((value) => {
      database = value,
      emit(CreateTodoDatabaseState()),
      print('our database file is opened')
    }).catchError((error)=>{
      print('Our error on open database')
    });
  }


  void insertDatabase({
    required title,
    required date,
    required time,
    required description,
    String status = 'new'
  }){
    database!.transaction((txn) async{
      txn.rawInsert('INSERT INTO tasks'
                    '(title,date,time,description,status) VALUES'
                    '("$title","$date","$time","$description","$status")'
      ).then((value){
        print('$value is successfully inserted');
        emit(InsertTodoDatabaseState());
        gettingDataFromDatabase(database);
      }).catchError((error){
        print("$error occur in inserting data");
      });
    });
  }

List tasks = [];
  void gettingDataFromDatabase(database){
    emit(LoadingDataFromDatabaseState());
    tasks = [];
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      for(var i in value) {
        tasks.add(i);
      }
      emit(GettingTodoDatabaseState());
      print('our data is appearing');
      print(value);
    }).catchError((err){
      print(err);
    });
  }

  void updateDataFromDatabase({
    required String title,
    required String date,
    required String time,
    required String description,
    required int id,
    String status = 'updated'
  }){
    database?.update('tasks', {
      "title":title,
      "date":date,
      "time":time,
      "description":description,
      "status":status
    },where: 'id =?',
    whereArgs: [id]).then((value) {
      print("$value is updated Successfully");
       emit(UpdateTodoDatabaseState());
      gettingDataFromDatabase(database);
    }).catchError((error){
        print(error);
    });

  }

  void deleteDataFromDatabase({
    required int id,
  }){
    database?.delete('tasks',where: 'id =?',whereArgs: [id]).then((value){
      print("$value Deleted Successfully");
      emit(DeleteTodoDatabaseState());
      gettingDataFromDatabase(database);
    }).catchError((error){
      print(error);
    });
  }

  void ChangeLanguageToMyanmar(BuildContext context){
    if(EasyLocalization.of(context)!.locale == const Locale('en','US')){
      context.locale = const Locale('my','MY');
    }
    emit(ChangeLanguageToMyanmarState());
  }

  void ChangeLanguageToEnglish(BuildContext context){
    if(EasyLocalization.of(context)!.locale == const Locale('my','MY')){
      context.locale = const Locale('en','US');
    }
    emit(ChangeLanguageToEnglishState());
  }
}