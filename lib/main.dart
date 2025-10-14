import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivek_yadav/theme.dart';
import 'package:vivek_yadav/services/theme_service.dart';
import 'package:vivek_yadav/screens/home_screen.dart';
import 'package:vivek_yadav/core/config/responsive_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Vivek Yadav - Flutter Architect, Expert and GDE',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeService.themeMode,
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: ResponsiveConfig.breakpoints,
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
