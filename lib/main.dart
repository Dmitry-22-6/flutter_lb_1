import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/tabs_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Слухаємо зміни теми
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Lab 3',
      themeMode: themeMode,
      // Налаштування СВІТЛОЇ теми
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      // Налаштування ТЕМНОЇ теми
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 131, 57, 0), // Твій помаранчевий колір
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 131, 57, 0),
          foregroundColor: Colors.white,
        ),
      ),
      home: const TabsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}