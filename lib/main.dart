import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> testWrite() async {
    await _db.collection('test').add({
      'message': 'Firestore connected',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return result.user;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AuthService().signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auri',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'App loads successfully'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  String _firestoreStatus = 'Firestore test not run';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _runDebugFirestoreTest() async {
    try {
      await FirestoreService().testWrite();

      if (!mounted) return;
      setState(() {
        _firestoreStatus = 'Firestore test write successful ✅';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _firestoreStatus = 'Firestore test failed ❌';
      });
      debugPrint('Firestore error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Firebase is connected ✅'),
            const SizedBox(height: 8),
            const Text('Anonymous auth is working 👤'),
            const SizedBox(height: 8),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(_firestoreStatus),
            const SizedBox(height: 16),
            if (kDebugMode)
              ElevatedButton(
                onPressed: _runDebugFirestoreTest,
                child: const Text('Test Firestore Write'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
