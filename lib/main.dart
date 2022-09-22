import 'package:firebase_authentication/models/word.dart';
import 'package:firebase_authentication/pages/anasayfa.dart';
import 'package:firebase_authentication/pages/girisekrani.dart';
import 'package:firebase_authentication/pages/editeprofile.dart';
import 'package:firebase_authentication/pages/kayitekrani.dart';
import 'package:firebase_authentication/pages/word_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'apis/word_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase'i çalıştır
  var firebaseApp = await Firebase.initializeApp();

  // ignore: prefer_const_constructors
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KayitEkrani(),
  ));
}

class KayitUygulama extends StatelessWidget {
  const KayitUygulama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KayitEkrani();
  }
}
