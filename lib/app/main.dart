// main.dart
import 'package:flutter/material.dart';
import 'package:listatarefa1/app/features/tasks/presentation/tasks_page.dart';

void main() {
  runApp(const ListTarefa());
}

class ListTarefa extends StatefulWidget {
  const ListTarefa({super.key});

  @override
  State<ListTarefa> createState() => _ListTarefa();
}

class _ListTarefa extends State<ListTarefa> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          primarySwatch: Colors.blueGrey,
          primaryColor: const Color.fromARGB(255, 26, 120, 163),
          useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.black, // Cor do texto/ícones na AppBar
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
