import 'package:flutter/material.dart';
import 'package:halal_life/main/presentation/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://flavcpihseylrouesqen.supabase.co',
    anonKey: 'sb_publishable_L8IvYd7uaaXKTRs_iRqzig_36rYUDTX',
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
