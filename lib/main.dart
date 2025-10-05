import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart'; 
import 'theme_provider.dart'; 

void main() {  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Login Page',
          debugShowCheckedModeBanner: false,                    
          themeMode: themeProvider.themeMode,
          
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1BA0E2), 
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1BA0E2),
              foregroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1BA0E2), 
              brightness: Brightness.dark,
            ),
          ),          
          home: const SplashScreen(), 
        );
      },
    );
  }
}