import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'HomePage.dart'; // your home page
import 'LoginPage.dart'; // login page

// ✅ Supabase keys
const String supabaseUrl = 'https://lxjcpxykjpqoogwaoaey.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx4amNweHlranBxb29nd2FvYWV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU2NzkwOTUsImV4cCI6MjA3MTI1NTA5NX0.5G2qHg1u7e-RmtIYQL3ehTg_-WB43IDdmgMaYwCUV_E';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // ✅ Wrap app in ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: GiveOnApp(),
    ),
  );
}

class GiveOnApp extends StatelessWidget {
  const GiveOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Give On',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
      ),
      home: const AuthWrapper(),
    );
  }
}

// ✅ Auth wrapper to check authentication state
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (mounted) {
        setState(() {
          // State will be updated when auth changes
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    
    // Check if user is authenticated
    if (session != null) {
      // User is logged in, show home page
      return const HomePage();
    } else {
      // User is not logged in, show login page
      return const LoginPage();
    }
  }
}
