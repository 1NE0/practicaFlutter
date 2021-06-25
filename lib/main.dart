import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/home.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  // firebase
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    MobileAds.instance.initialize();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: home(),
    );
  }
}
