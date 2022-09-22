import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase_islemleri/firenbase_islemleri.dart';
import 'package:firebase_authentication/main.dart';
import 'package:firebase_authentication/models/word.dart';
import 'package:firebase_authentication/pages/anasayfa.dart';
import 'package:firebase_authentication/pages/girisekrani.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../apis/word_api.dart';
import '../fake-data/word_list.dart';

class KayitEkrani extends StatefulWidget {
  @override
  _KayitEkraniState createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
//Kayıt Parametreleri Tutucular
  var firebase = FirebaseFirestore.instance;

  late String email, sifre, name, username;
  late bool stateControl;

  var _formAnahtari = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      stateControl = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Kayıt"),
        centerTitle: true,
      ),
      body: stateControl
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formAnahtari,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (alinanMail) {
                          setState(() {
                            email = alinanMail;
                          });
                        },
                        validator: (alinanMail) {
                          return alinanMail!.contains("@")
                              ? null
                              : "Mail Geçersiz";
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email ..",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onChanged: (alinanSifre) {
                          setState(() {
                            sifre = alinanSifre;
                          });
                        },
                        validator: (alinanSifre) {
                          return alinanSifre!.length >= 6
                              ? null
                              : "En az 6 karakter";
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password..",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onChanged: (alinanName) {
                          setState(() {
                            name = alinanName;
                          });
                        },
                        validator: (alinanName) {
                          return alinanName!.length >= 3
                              ? null
                              : "En az 3 karakter";
                        },
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onChanged: (alinanUserName) {
                          setState(() {
                            username = alinanUserName;
                          });
                        },
                        validator: (alinanUserName) {
                          return alinanUserName!.length >= 1
                              ? null
                              : "En az 1 karakter";
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            kayitEkle();
                          },
                          child: Text("Kaydol"),
                          style: ElevatedButton.styleFrom(
                            textStyle: GoogleFonts.roboto(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              //Giriş sayfasına gitsin
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => GirisEkrani()));
                            },
                            child: const Text(
                              "Zaten hesabım var",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

//email ve şifreye göre firebase kullanıcı ekle
  Future<void> kayitEkle() async {
    setState(() {
      stateControl = true;
    });
    if (_formAnahtari.currentState!.validate()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: sifre)
          .then((user) async {
        //Başarılıysa Ana sayfaya git

        //
      }).catchError((hata) {
        //başarılı değilse hata mesajı ver
        Fluttertoast.showToast(msg: hata);
      }).then((user) async {
        FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          "sayac": 10,
          "email": email,
          "username": username,
          "password": sifre,
          "name": name,
          "uid": FirebaseAuth.instance.currentUser?.uid,
        });
        await createWords(FakeData.wordList);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainPage()),
            (Route<dynamic> route) => false);
        // FirebaseFirestore.instance.collection("users").doc().set({
        //   "email": email,
        //   "username": username,
        //   "password": sifre,
        //   "name": name
        // });
      });
    }
  }
}
