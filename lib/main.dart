import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_api_dicoding/screens/add_new_story_screen.dart';
import 'package:story_api_dicoding/screens/home_screen.dart';
import 'package:story_api_dicoding/screens/login_screen.dart';
import 'package:story_api_dicoding/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: '/login',
    routerNeglect: true,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => HomeScreen(),
        routes: [
          GoRoute(
            path: '/add-story',
            name: 'add_new_story',
            builder: (context, state) => AddNewStory(),
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final authRoute = ["/register", "/login"];
      final isAuthRoute = authRoute.contains(state.matchedLocation);

      if (token == null && !isAuthRoute) return state.namedLocation('login');
      if (token != null && isAuthRoute) return state.namedLocation('home');

      return null;
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter WRI - Story API Dicoding',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
