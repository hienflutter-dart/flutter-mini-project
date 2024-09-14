import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavoriteProvider.dart';
import 'trangchu.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // Add other providers here if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => FavoriteProvider(),
        child: Trangchu(isAuthenticated: false),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}