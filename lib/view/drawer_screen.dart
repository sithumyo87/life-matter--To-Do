import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/cubit/cubit.dart';
import '../controller/cubit/states.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
           var cubit = TodoCubit.get(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Change Your Language".tr(),style: Theme.of(context).textTheme.bodyText1,),
              SizedBox(height: 10,),
              MaterialButton(color: Colors.deepOrange,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),onPressed: (){
                cubit.ChangeLanguageToEnglish(context);
              },child: Text('English'.tr()),),
              MaterialButton(color: Colors.deepOrange,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),onPressed: (){
                cubit.ChangeLanguageToMyanmar(context);
              },child: Text('Myanmar'.tr()),)
            ],
          );
        });
  }
}
