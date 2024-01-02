import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants/app_colors.dart';
import 'package:twitter/constants/firebase_consts.dart';
import 'package:twitter/providers/auth_provider.dart';
import 'package:twitter/providers/home_provider.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';
import 'package:twitter/screens/login.dart';
import 'package:twitter/screens/nav_bar.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TweetProvider())
      ],
      child: GetMaterialApp(
        themeMode: ThemeMode.system,
        theme: ThemeData(
          
            scaffoldBackgroundColor: Colors.black,
            hintColor: AppColors.greyColor,
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
            )),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue,),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("An error occurred"),
              );
            } else if (!snapshot.hasData) {
              return const Login();
            } else {
              return const NavBar();
            }
          },
        ),
      ),
    );
  }
}
