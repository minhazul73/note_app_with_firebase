import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/all_notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllNotes(),
      

      // initialRoute: '/',
      // getPages: [
      //   GetPage(name: '/', page: () => const Home()),
      //   GetPage(name: '/all-notes', page: () => const AllNotes()), // Define route for AllNotes
      // ],

    );
  }
}