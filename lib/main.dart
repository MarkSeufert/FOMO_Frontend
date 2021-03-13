import 'package:flutter/material.dart';
import 'screen/login.dart';
import 'screen/profile.dart';
import 'screen/map.dart';
import 'screen/splash.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';
import 'widget/message_infowindow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(
    ChangeNotifierProvider(
        create: (context) => InfowindowModel(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (_) => SplashScreen(),
          '/login': (_) => LoginScreen(),
          '/profile': (_) => ProfileScreen(),
          '/map': (_) => MapScreen(),
        });
  }
}
