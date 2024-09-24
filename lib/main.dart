import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/logic/quiz/bloc/get_questions_bloc.dart';
import 'package:quiz_app/logic/quiz/bloc/quiz_bloc.dart';
import 'package:quiz_app/views/bottom%20nav/bottom_nav.dart';

import 'logic/auth/bloc/sign_in_bloc.dart';
import 'logic/auth/bloc/sign_up_bloc.dart';
import 'logic/bottom_nav/cubit/bottom_nav_cubit.dart';
import 'utils/color_theme.dart';
import 'utils/constant_assets.dart';
import 'views/auth/authentication.dart';

Future<void> main() async {
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => SignInBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => GetQuestionsBloc()),
        BlocProvider(create: (context) => QuizBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (mounted) {
            if (user == null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AuthenticationScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavScreen()),
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            margin: EdgeInsets.only(left: size.width * 0.05, right: 20),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              width: size.width,
              height: size.width,
              ConstantAssets.todo,
            )),
      ),
    );
  }
}
