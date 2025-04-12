import 'package:avoura/core/services/auth_services.dart';
import 'package:avoura/core/services/crud_services.dart';
import 'package:avoura/viewmodels/auth/auth_bloc.dart';
import 'package:avoura/viewmodels/contact/contact_bloc.dart';
import 'package:avoura/views/screens/add_contact_screen.dart';
import 'package:avoura/views/screens/home.dart';
import 'package:avoura/views/screens/login_screen.dart';
import 'package:avoura/views/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthBloc for authentication
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
        // Provide ContactsBloc for contacts management
        BlocProvider(
          create: (context) => ContactsBloc(CRUDService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts App',
        theme: ThemeData(
          brightness: Brightness.dark, // Set the app to dark mode
          scaffoldBackgroundColor: Colors.black, // Black background
          textTheme: GoogleFonts.soraTextTheme(
            ThemeData.dark().textTheme.apply(
                  bodyColor: Color(0xFF39FF14), // Neon green text
                  displayColor: Color(0xFF39FF14), // Neon green for headings
                ),
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF9C27B0), // Neon green for primary elements
            onPrimary: Colors.black, // Text color on primary elements
            secondary: Color(0xFF39FF14), // Neon green for secondary elements
            onSecondary: Colors.black, // Text color on secondary elements
            background: Colors.black, // Black background
            onBackground: Color(0xFF39FF14), // Neon green text on background
            surface: Colors.black, // Black surface (e.g., cards)
            onSurface: Color(0xFF39FF14), // Neon green text on surface
            error: Colors.redAccent, // Red for errors
            onError: Colors.black, // Text color on error elements
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color(0xFF39FF14)), // Neon green border
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color(0xFF39FF14),
                  width: 2), // Neon green border on focus
            ),
            labelStyle:
                TextStyle(color: Color(0xFF39FF14)), // Neon green labels
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF39FF14), // Neon green button
              foregroundColor: Colors.black, // Black text on button
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                  color: Color(0xFF39FF14)), // Neon green border
              foregroundColor: Color(0xFF39FF14), // Neon green text
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF39FF14), // Neon green FAB
            foregroundColor: Colors.black, // Black icon on FAB
          ),
        ),
        routes: {
          "/": (context) => const CheckUser(),
          "/home": (context) => const Homepage(),
          "/signup": (context) => SignUpPage(),
          "/login": (context) => LoginPage(),
          "/add": (context) => AddContact(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    super.initState();
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
