import 'package:flutter/material.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Page'),
      ),
      body: SafeArea(
        child: const Center(
          child: Text('Welcome to the Car Page!'),
        ),
      ),
    );
  }
}