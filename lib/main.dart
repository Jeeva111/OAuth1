import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const NetsuiteApiDemo());
}

class NetsuiteApiDemo extends StatelessWidget {
  const NetsuiteApiDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
