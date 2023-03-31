import 'package:cdao/providers/firebasertdb_service.dart';
import 'package:cdao/providers/firestore_service.dart';
import 'package:cdao/providers/storage_service.dart';
import 'package:cdao/screens/earlySignUp.dart';
import 'package:cdao/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAzL8860aWxxrUyeV45RBnIicLGaVPRz7g",
      authDomain: "coffee-dao.firebaseapp.com",
      databaseURL: "https://coffee-dao-default-rtdb.firebaseio.com",
      projectId: "coffee-dao",
      storageBucket: "coffee-dao.appspot.com",
      messagingSenderId: "890475915685",
      appId: "1:890475915685:web:dd9f6e950b056f571e604c"
),
  );

  runApp(const CDAO()
      // EasyLocalization(
      //   supportedLocales: const [Locale('en', ''), Locale('es', '')],
      //   path: 'lib/assets/translations',
      //   fallbackLocale: const Locale('en', ''),
      //   child: const DPA())
      );
}

class CDAO extends StatelessWidget {
  const CDAO({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.orange,
      ).copyWith(
        secondary: Colors.blueGrey,
      ),
      textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.white)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: Colors.orange,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
    return MultiProvider(
            providers: [
                Provider<FirestoreService>(
                  create: (context) => FirestoreService(),
                ),
                Provider<StorageService>(
                  create: (context) => StorageService(),
                ),
                Provider<DB>(
                  create: (context) => DB(),
                ),
              ],
            child:  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Coffee DAO',
          theme: themeData,
          home: const EarlySignUpScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            EarlySignUpScreen.routeName: (ctx) => const EarlySignUpScreen(),
          }),
    );
  }
}
