import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app1/screens/login.dart';
import 'package:shop_app1/shared/bloc/app_cubit/cubit.dart';
import 'package:shop_app1/shared/bloc/app_cubit/states.dart';
import 'package:shop_app1/shared/components/components.dart';
import 'package:shop_app1/shared/network/local/blocObserver.dart';
import 'package:shop_app1/shared/network/local/dio_helper.dart';
import 'package:shop_app1/shared/network/remote/cache_helper.dart';
// تأكد أن المسار صحيح لملف الـ observer عندك

import 'package:shop_app1/shared/styles/themes.dart';

import 'homeLayout/home_layout.dart';
import 'on_boarding/on_boarding.dart';


String? token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الـ SharedPreferences أو أي كاش تستخدمه
  await CacheHelper.init();

  // تهيئة dio قبل أي عمليات طلبات
  DioHelper.init();

  // تعيين Observer للـ Bloc/ Cubit
  Bloc.observer = MyBlocObserver();

  // قراءة القيم المحفوظة (مراعاة شكل دالتك getData)
  bool? onBoarding = CacheHelper.getData('onBoarding');
  token = CacheHelper.getData('token');
  token ="okkkkk";
  // تحديد أول شاشة
  Widget startWidget;
  if (onBoarding != null) {
    if (token != null) {
      startWidget = const ShopLayout();
    } else {
      startWidget = ShopLogin();
    }
  } else {
    startWidget = const OnBoarding();
  }

  runApp(MyApp(widget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget widget;

  const MyApp({Key? key, required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()
            ..getHomeData()
            ..getCategories()
            ..getFav()
            ..getUsrData(),
        ),

      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: widget,
          );
        },
      ),
    );
  }
}
