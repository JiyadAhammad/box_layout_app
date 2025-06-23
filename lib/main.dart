import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feature/Interactive_box_layout/provider/box_layout_provider.dart';
import 'feature/Interactive_box_layout/view/interactive_layout_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BoxLayoutProvider>(
          create: (context) => BoxLayoutProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Box Layout',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 2),
        ),
        home: const InteractiveLayoutPage(),
      ),
    );
  }
}
