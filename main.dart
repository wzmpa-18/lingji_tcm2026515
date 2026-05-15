import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/user_provider.dart';
import 'providers/tcm_provider.dart';
import 'providers/acupuncture_provider.dart';
import 'providers/fortune_provider.dart';
import 'providers/community_provider.dart';
import 'providers/lingji_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..init()),
        ChangeNotifierProvider(create: (_) => TCMProvider()..loadMasters()),
        ChangeNotifierProvider(create: (_) => AcupunctureProvider()..loadAcupoints()),
        ChangeNotifierProvider(create: (_) => FortuneProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => LingjiProvider()),
      ],
      child: const App(),
    ),
  );
}
