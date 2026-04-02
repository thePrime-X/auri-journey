import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// Service for Firestore
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> testWrite() async {
    final user = _auth.currentUser;

    // check if user exists
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    // print user info
    debugPrint('Current UID: ${user.uid}');
    debugPrint('Is anonymous: ${user.isAnonymous}');

    // write data to Firestore
    await _db.collection('users').doc(user.uid).set({
      'displayName': 'Anonymous Tester1',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
      'currentLevel': 'S1_L1',
      'totalXP': 0,
      'puzzlesCompleted': 0,
    }, SetOptions(merge: true));
  }
}

// Auth service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    // login without email
    final result = await _auth.signInAnonymously();
    return result.user;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // start Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // login user
  await AuthService().signInAnonymously();

  runApp(const MyApp());
}

// main app
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
      _counter++; // increase number
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

      // print error
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

            // show counter
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 16),
            Text(_firestoreStatus),

            const SizedBox(height: 16),

            // test button (debug only)
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