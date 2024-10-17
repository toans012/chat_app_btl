import 'package:chat_customer/screens/home/home_screen.dart';
import 'package:chat_customer/screens/search/search_screen.dart';
import 'package:chat_customer/screens/sign_in/signin_screen.dart';
import 'package:chat_customer/screens/sign_up/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    mq = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: {
          '/': (context) => FutureBuilder<bool>(
                future: authService.isLoggedIn(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.data == true) {
                      return const HomeScreen();
                    } else {
                      return const SigninScreen();
                    }
                  }
                },
              ),
          '/sign-up': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchScreen(),
        },
      ),
    );
  }
}
