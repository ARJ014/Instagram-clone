import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freelancer/page/loginscreen.dart';
import 'package:freelancer/provider/user_provider.dart';
import 'package:freelancer/responsive/phonescreen.dart';
import 'package:freelancer/responsive/responsive_layout_screen.dart';
import 'package:freelancer/responsive/webscreen.dart';
import 'package:freelancer/utils/colors.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyD9Xfh_222SmhY-QwMU-O9nRADst55GwMw",
            projectId: "storage-testinf",
            storageBucket: "storage-testinf.appspot.com",
            messagingSenderId: "195071508537",
            appId: "1:195071508537:web:70ff3a1b5d09a7c3cd8de8"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
            backgroundColor: webBackgroundColor,
            scaffoldBackgroundColor: webBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Responsive_layout(PhoneScreen(), WebScreen());
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: primaryColor));
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
