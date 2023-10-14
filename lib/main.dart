import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sql_test/app_cubit/app_cubit.dart';
import 'package:sql_test/app_cubit/app_states.dart';
import 'package:sql_test/controller/cubit/cubit.dart';
import 'package:sql_test/style/theme.dart';
import 'package:sql_test/view/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   bool isDark = sharedPreferences.getBool("isDark") ?? false;
  runApp(EasyLocalization(
      supportedLocales:const [Locale('en', 'US'), Locale('my', 'MY')],
      path: 'assets/translations', // <-- change the path of the translation files 
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(isDark: isDark,)
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({required this.isDark,super.key});
   final bool isDark;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => TodoCubit()..createDatabase()),
        BlocProvider(create: (BuildContext context) => AppCubit()..changeThemeMode(darkMode: isDark)),
      ],
      child: BlocBuilder<AppCubit,AppStates>(
        builder: (BuildContext context,state){
          var cubit = AppCubit.get(context);
          return MaterialApp(
          title: 'Flutter Demo',
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
         themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
        locale: context.locale,
          home:AnimatedSplashScreen(
        splash: Image.asset('assets/images/logo.png',width: 100,height: 100,),
        nextScreen: HomeScreen(),
        splashIconSize:double.infinity,
        splashTransition: SplashTransition.decoratedBoxTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.deepOrangeAccent,
          ),
        );
        },
      ),
    );
  }
}

  