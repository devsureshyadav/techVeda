import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tech_veda/bootstrap.dart';
import 'package:tech_veda/features/version/provider/version_provider.dart';
import 'package:tech_veda/screens/home_page.dart';
import 'package:tech_veda/theme/app_theme.dart';

Future<void> main() async {
  await bootstrap(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => VersionProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tech Veda',
      theme: buildAppTheme(),
      home: const HomePage(title: 'T E C H V E D A'),
    );
  }
}
