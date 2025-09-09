import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double dx = 100;
  double dy = 100;
  double xSpeed = 3; 
  double ySpeed = 3; 

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1), 
    )..addListener(() {
        setState(() {
          dx += xSpeed;
          dy += ySpeed;

          
          if (dx <= 0 || dx >= MediaQuery.of(context).size.width - 120) {
            xSpeed = -xSpeed;
          }
          
          if (dy <= 0 || dy >= MediaQuery.of(context).size.height - 120) {
            ySpeed = -ySpeed;
          }
        });
      });

    _controller.repeat(); 

    
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), 
      body: Stack(
        children: [
          Positioned(
            left: dx,
            top: dy,
            child: Image.asset(
              'assets/images/logo.png', 
              width: 120,
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
