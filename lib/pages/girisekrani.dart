import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/firebase_islemleri/firenbase_islemleri.dart';
import 'package:firebase_authentication/pages/anasayfa.dart';
import 'package:firebase_authentication/pages/kayitekrani.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  //giriş parametreleri
  late String email, sifre;
  //doğrulama anahtarı
  var _formAnahtari = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: Form(
        key: _formAnahtari,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (alinanEmail) {
                    email = alinanEmail;
                  },
                  validator: (alinanEmail) {
                    return alinanEmail!.contains("@") ? null : "Mail Geçersiz";
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  onChanged: (alinanSifre) {
                    sifre = alinanSifre;
                  },
                  validator: (alinanSifre) {
                    return alinanSifre!.length >= 6 ? null : "En az 6 karakter";
                  },
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      //email ve şifreye göre doğrulama yapıp giriş yapacak
                      girisYap();
                    },
                    child: Text("Giriş")),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => KayitEkrani()));
                  //     wordAdd();
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Hesap Oluştur",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

//email ve şifreye göre
  void girisYap() {
    if (_formAnahtari.currentState!.validate()) {
      //Giris Yap
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: sifre)
          .then((user) {
        //eğer başarılıysa ana sayfaya gitsin
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MainPage()), (route) => false);
      }).catchError((hata) {
        Fluttertoast.showToast(msg: hata);
      });
    } else {
      Text("Eksik veya yanlış e-posta şifre girdiniz.");
    }
  }
}
