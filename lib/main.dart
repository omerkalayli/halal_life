import 'package:cloudflare_r2/cloudflare_r2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/notifiers/city_notifier.dart';
import 'package:halal_life/main/presentation/pages/main_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  CloudFlareR2.init(
    accountId: dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '',
    accessKeyId: dotenv.env['CLOUDFLARE_ACCESS_KEY_ID'] ?? '',
    secretAccessKey: dotenv.env['CLOUDFLARE_SECRET_ACCESS_KEY'] ?? '',
  );

  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    _initCityDb();
  }

  Future<void> _initCityDb() async {
    await ref.read(cityNotifierProvider.notifier).initDb();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: appBackgroundColor),
        scaffoldBackgroundColor: appBackgroundColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: mint,
          selectionHandleColor: mint,
          selectionColor: mint,
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
          selectedColor: darkMint,
          iconColor: darkMint,
          textColor: Colors.black,
          selectedTileColor: mint.withValues(alpha: .1),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
