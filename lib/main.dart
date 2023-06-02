import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/src/services/services.dart';
import 'package:band_names/src/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: MaterialApp(
        title: 'BandNames',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'home',
        routes: {
          'home': (_) => const HomeScreen(),
          'status': (_) => const StatusScreen()
        }
      ),
    );
  }
}
