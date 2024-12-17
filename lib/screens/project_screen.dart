import 'package:flutter/material.dart';

class ProJect extends StatelessWidget {
  const ProJect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProJect Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to ProJect Screen!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
