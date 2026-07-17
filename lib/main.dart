import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/check_in.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive with a proper storage directory
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(CheckInAdapter());

  // Open the box (this creates it if it doesn't exist)
  await Hive.openBox<CheckIn>('check_ins');

  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({Key? key, required this.storageService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check-In App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(storageService: storageService),
      debugShowCheckedModeBanner: false,
    );
  }
}